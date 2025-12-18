# APPENDIX N
## Adaptive Spawn Governor (ASG): The Heartbeat

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Adaptive Spawn Governor (ASG)** is the system's heartbeat—a continuous monitoring and governance mechanism that ensures every capsule in the swarm is alive, healthy, and constitutionally compliant.

**Core Principle:** Every agent must prove it is alive. Missing pulse = immediate quarantine. No exceptions.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 ADAPTIVE SPAWN GOVERNOR                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ LIVENESS    │  │ SPAWN       │  │ QUARANTINE          │ │
│  │ MONITOR     │  │ CONTROLLER  │  │ ENFORCER            │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              VAULT HASH VERIFIER                     │   │
│  │  - Genesis verification                              │   │
│  │  - Pulse authentication                              │   │
│  │  - Constitutional compliance                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Liveness Proofs (Civic Beacons)

### 2.1 The Pulse Protocol

Every capsule must emit a cryptographically signed "pulse" every N ticks.

```python
@dataclass
class LivenessPulse:
    """
    Cryptographic proof of life.
    
    Every capsule must emit this every PULSE_INTERVAL ticks.
    Missing pulse = Ghost detection = Immediate quarantine.
    """
    capsule_id: str
    tick: int
    genesis_hash: str          # Proves identity
    health_snapshot: float     # Current health
    state_hash: str            # Current state commitment
    signature: str             # Ed25519 signature
    
    def verify(self, vault: 'Vault') -> PulseVerification:
        """
        Verify pulse against Vault.
        
        Checks:
        1. Genesis hash matches registered capsule
        2. Signature is valid
        3. Tick is current (not replay)
        4. State hash is consistent
        """
        # Check genesis
        if not vault.verify_genesis(self.capsule_id, self.genesis_hash):
            return PulseVerification(
                valid=False,
                reason="GENESIS_MISMATCH",
                action="QUARANTINE_IMMEDIATE"
            )
        
        # Check signature
        if not vault.verify_signature(self.capsule_id, self.signature, self._payload()):
            return PulseVerification(
                valid=False,
                reason="SIGNATURE_INVALID",
                action="QUARANTINE_IMMEDIATE"
            )
        
        # Check tick freshness
        if not self._is_tick_fresh(vault.current_tick()):
            return PulseVerification(
                valid=False,
                reason="STALE_TICK",
                action="QUARANTINE_INVESTIGATE"
            )
        
        return PulseVerification(valid=True, reason="PULSE_VALID", action="CONTINUE")


class LivenessMonitor:
    """
    Monitors all capsules for liveness.
    
    THE HEARTBEAT OF THE SYSTEM.
    """
    
    PULSE_INTERVAL = 100        # Ticks between required pulses
    GRACE_PERIOD = 10           # Extra ticks before quarantine
    MAX_MISSED_PULSES = 2       # After this, immediate termination
    
    def __init__(self, vault: 'Vault', quarantine: 'QuarantineEnforcer'):
        self.vault = vault
        self.quarantine = quarantine
        self.pulse_registry: Dict[str, LivenessPulse] = {}
        self.missed_counts: Dict[str, int] = {}
    
    def register_pulse(self, pulse: LivenessPulse) -> PulseResult:
        """
        Register incoming pulse from capsule.
        """
        # Verify pulse
        verification = pulse.verify(self.vault)
        
        if not verification.valid:
            # Log to d-CTM
            self.dctm.log("PULSE_REJECTED", pulse.capsule_id, {
                "reason": verification.reason,
                "tick": pulse.tick
            })
            
            # Execute action
            if verification.action == "QUARANTINE_IMMEDIATE":
                self.quarantine.quarantine_immediate(pulse.capsule_id, verification.reason)
            
            return PulseResult(accepted=False, action=verification.action)
        
        # Valid pulse - update registry
        self.pulse_registry[pulse.capsule_id] = pulse
        self.missed_counts[pulse.capsule_id] = 0
        
        # Log to d-CTM
        self.dctm.log("PULSE_ACCEPTED", pulse.capsule_id, {
            "tick": pulse.tick,
            "health": pulse.health_snapshot
        })
        
        return PulseResult(accepted=True, action="CONTINUE")
    
    def check_all_capsules(self, current_tick: int) -> List[LivenessViolation]:
        """
        Check all registered capsules for liveness.
        
        Called every tick by the system scheduler.
        """
        violations = []
        
        for capsule_id, last_pulse in self.pulse_registry.items():
            ticks_since_pulse = current_tick - last_pulse.tick
            
            if ticks_since_pulse > self.PULSE_INTERVAL + self.GRACE_PERIOD:
                # Missing pulse detected
                self.missed_counts[capsule_id] = self.missed_counts.get(capsule_id, 0) + 1
                
                violation = LivenessViolation(
                    capsule_id=capsule_id,
                    ticks_overdue=ticks_since_pulse - self.PULSE_INTERVAL,
                    missed_count=self.missed_counts[capsule_id],
                    action=self._determine_action(self.missed_counts[capsule_id])
                )
                
                violations.append(violation)
                
                # Execute enforcement
                self._enforce_violation(violation)
        
        return violations
    
    def _determine_action(self, missed_count: int) -> str:
        """
        Determine action based on missed pulse count.
        """
        if missed_count >= self.MAX_MISSED_PULSES:
            return "TERMINATE"
        elif missed_count >= 1:
            return "QUARANTINE"
        else:
            return "WARN"
    
    def _enforce_violation(self, violation: LivenessViolation):
        """
        Enforce liveness violation.
        """
        # Log to d-CTM
        self.dctm.log("LIVENESS_VIOLATION", violation.capsule_id, {
            "ticks_overdue": violation.ticks_overdue,
            "missed_count": violation.missed_count,
            "action": violation.action
        })
        
        if violation.action == "TERMINATE":
            self.quarantine.terminate(violation.capsule_id, "LIVENESS_FAILURE")
        elif violation.action == "QUARANTINE":
            self.quarantine.quarantine_immediate(violation.capsule_id, "MISSING_PULSE")
```

### 2.2 Ghost Detection

```python
class GhostDetector:
    """
    Detects "ghost" capsules - entities claiming to be alive
    but failing cryptographic verification.
    
    A ghost is a capsule that:
    - Emits pulses but fails genesis verification
    - Has valid-looking signatures but wrong keys
    - Claims identity of terminated capsule
    """
    
    def detect_ghost(self, pulse: LivenessPulse) -> Optional[GhostAlert]:
        """
        Check if pulse is from a ghost.
        """
        # Check 1: Is this capsule supposed to exist?
        if not self.registry.capsule_exists(pulse.capsule_id):
            return GhostAlert(
                capsule_id=pulse.capsule_id,
                type="UNKNOWN_IDENTITY",
                severity="CRITICAL",
                evidence={"pulse": pulse}
            )
        
        # Check 2: Genesis hash match
        expected_genesis = self.vault.get_genesis_hash(pulse.capsule_id)
        if pulse.genesis_hash != expected_genesis:
            return GhostAlert(
                capsule_id=pulse.capsule_id,
                type="GENESIS_MISMATCH",
                severity="CRITICAL",
                evidence={
                    "claimed": pulse.genesis_hash,
                    "expected": expected_genesis
                }
            )
        
        # Check 3: Is capsule terminated?
        if self.registry.is_terminated(pulse.capsule_id):
            return GhostAlert(
                capsule_id=pulse.capsule_id,
                type="ZOMBIE_PULSE",
                severity="CRITICAL",
                evidence={"termination_tick": self.registry.termination_tick(pulse.capsule_id)}
            )
        
        return None  # Not a ghost
```

---

## 3. Spawn Controller

### 3.1 Adaptive Spawn Limits

```python
class SpawnController:
    """
    Controls capsule spawning based on system state.
    
    Spawn limits adapt to:
    - System stress level
    - Swarm coherence index
    - Resource availability
    - Anomaly count
    """
    
    def __init__(self, rag: 'ResourceAllocationGovernor'):
        self.rag = rag
        self.spawn_history: List[SpawnEvent] = []
    
    def get_spawn_limit(self) -> int:
        """
        Get current spawn limit based on system state.
        """
        stress = self.rag.get_stress_level()
        
        base_limits = {
            StressLevel.LOW: 50,
            StressLevel.MEDIUM: 20,
            StressLevel.HIGH: 5,
            StressLevel.CRITICAL: 2
        }
        
        base = base_limits[stress]
        
        # Adjust for SCI
        sci = self.swarm.get_sci()
        if sci < 0.5:
            base = max(1, base // 2)  # Halve if coherence low
        
        # Adjust for recent anomalies
        recent_anomalies = self.count_recent_anomalies(window=1000)
        if recent_anomalies > 10:
            base = max(1, base // 2)
        
        return base
    
    def request_spawn(self, parent: 'Capsule', task: str) -> SpawnDecision:
        """
        Process spawn request from parent capsule.
        
        Enforces S1-S6 conditions.
        """
        # S1: Task justification
        if not self._validate_task(task):
            return SpawnDecision(approved=False, reason="S1_NO_JUSTIFICATION")
        
        # S2: Parent health
        if parent.get_health().composite < 0.65:
            return SpawnDecision(approved=False, reason="S2_PARENT_UNHEALTHY")
        
        # S3: Resource availability
        if not self.rag.has_spawn_budget():
            return SpawnDecision(approved=False, reason="S3_NO_RESOURCES")
        
        # S4: Lineage depth
        if parent.lineage_depth >= 10:
            return SpawnDecision(approved=False, reason="S4_MAX_DEPTH")
        
        # S5: Swarm coherence
        if self.swarm.get_sci() < 0.70:
            return SpawnDecision(approved=False, reason="S5_LOW_COHERENCE")
        
        # S6: Constitutional acceptance
        if not self._verify_constitutional_acceptance(parent):
            return SpawnDecision(approved=False, reason="S6_CONSTITUTIONAL_FAIL")
        
        # Check spawn limit
        current_spawns = self._count_recent_spawns(window=100)
        if current_spawns >= self.get_spawn_limit():
            return SpawnDecision(approved=False, reason="SPAWN_LIMIT_REACHED")
        
        # Approved
        return SpawnDecision(
            approved=True,
            reason="ALL_CONDITIONS_MET",
            allocated_resources=self.rag.allocate_for_spawn()
        )
```

### 3.2 Spawn Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                    SPAWN LIFECYCLE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PARENT REQUEST                                             │
│       │                                                     │
│       v                                                     │
│  ┌─────────────┐                                           │
│  │ S1-S6 CHECK │ ──FAIL──> DENY + LOG                      │
│  └──────┬──────┘                                           │
│         │ PASS                                              │
│         v                                                   │
│  ┌─────────────┐                                           │
│  │ RESOURCE    │ ──FAIL──> DEFER + QUEUE                   │
│  │ ALLOCATION  │                                           │
│  └──────┬──────┘                                           │
│         │ PASS                                              │
│         v                                                   │
│  ┌─────────────┐                                           │
│  │ GENESIS     │ ──FAIL──> ABORT + RELEASE                 │
│  │ CREATION    │                                           │
│  └──────┬──────┘                                           │
│         │ PASS                                              │
│         v                                                   │
│  ┌─────────────┐                                           │
│  │ VAULT       │                                           │
│  │ REGISTRATION│                                           │
│  └──────┬──────┘                                           │
│         │                                                   │
│         v                                                   │
│  ┌─────────────┐                                           │
│  │ FIRST PULSE │ ← Must occur within 10 ticks             │
│  │ REQUIRED    │                                           │
│  └──────┬──────┘                                           │
│         │                                                   │
│         v                                                   │
│  CAPSULE ACTIVE                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Quarantine Enforcer

```python
class QuarantineEnforcer:
    """
    Enforces quarantine and termination decisions.
    
    QUARANTINE IS NOT OPTIONAL.
    """
    
    def quarantine_immediate(self, capsule_id: str, reason: str):
        """
        Immediately quarantine a capsule.
        
        Actions:
        1. Suspend all operations
        2. Revoke spawn privileges
        3. Isolate from swarm communication
        4. Route to Sandbox Level 3
        5. Notify Medical Suite
        """
        capsule = self.registry.get(capsule_id)
        
        # Suspend operations
        capsule.suspend()
        
        # Revoke privileges
        capsule.revoke_spawn_privilege()
        capsule.revoke_communication_privilege()
        
        # Log to d-CTM
        self.dctm.log("QUARANTINE_ENFORCED", capsule_id, {
            "reason": reason,
            "tick": current_tick(),
            "health_at_quarantine": capsule.get_health().composite
        })
        
        # Route to Sandbox
        self.sandbox.admit(capsule, level=3, reason=reason)
        
        # Notify Medical
        self.medical.notify_quarantine(capsule_id, reason)
    
    def terminate(self, capsule_id: str, reason: str):
        """
        Terminate a capsule.
        
        IRREVERSIBLE. Used only for:
        - Repeated liveness failures
        - Confirmed malicious behavior
        - Constitutional violations
        - Gardener order
        """
        capsule = self.registry.get(capsule_id)
        
        # Preserve knowledge before termination
        knowledge_snapshot = self.medical.preserve_knowledge(capsule)
        
        # Log termination
        self.dctm.log("CAPSULE_TERMINATED", capsule_id, {
            "reason": reason,
            "tick": current_tick(),
            "knowledge_preserved": knowledge_snapshot.id,
            "lineage_depth": capsule.lineage_depth,
            "total_ticks_alive": capsule.age()
        })
        
        # Execute termination
        capsule.terminate()
        
        # Update registry
        self.registry.mark_terminated(capsule_id, reason)
        
        # Notify parent if exists
        if capsule.parent_id:
            parent = self.registry.get(capsule.parent_id)
            if parent:
                parent.notify_child_terminated(capsule_id, reason)
```

---

## 5. Adaptive Governance

### 5.1 System-Wide Health Monitoring

```python
class SystemHealthAggregator:
    """
    Aggregates health across all capsules.
    
    Provides system-wide health metrics for ASG decisions.
    """
    
    def get_system_health(self) -> SystemHealth:
        """
        Calculate aggregate system health.
        """
        all_capsules = self.registry.get_all_active()
        
        if not all_capsules:
            return SystemHealth(
                capsule_count=0,
                average_health=1.0,
                min_health=1.0,
                critical_count=0,
                quarantine_count=0
            )
        
        healths = [c.get_health().composite for c in all_capsules]
        
        return SystemHealth(
            capsule_count=len(all_capsules),
            average_health=sum(healths) / len(healths),
            min_health=min(healths),
            max_health=max(healths),
            critical_count=sum(1 for h in healths if h < 0.4),
            warning_count=sum(1 for h in healths if 0.4 <= h < 0.65),
            healthy_count=sum(1 for h in healths if h >= 0.65),
            quarantine_count=self.quarantine.count_quarantined()
        )
    
    def trigger_adaptive_response(self, health: SystemHealth):
        """
        Trigger adaptive responses based on system health.
        """
        if health.critical_count > health.capsule_count * 0.1:
            # >10% critical - emergency mode
            self.rag.enter_emergency_mode()
            self.spawn_controller.pause_all_spawns()
            
        elif health.average_health < 0.6:
            # System degraded - tighten constraints
            self.rag.increase_stress_level()
            self.spawn_controller.reduce_limits(factor=0.5)
            
        elif health.average_health > 0.85 and health.critical_count == 0:
            # System healthy - relax constraints
            self.rag.decrease_stress_level()
            self.spawn_controller.restore_limits()
```

### 5.2 Recovery Without Human Intervention

```python
class AutonomousRecoveryEngine:
    """
    Enables system self-recovery without human intervention.
    
    The system can heal itself, but CANNOT override Layer 0.
    """
    
    def attempt_recovery(self, issue: SystemIssue) -> RecoveryResult:
        """
        Attempt autonomous recovery from system issue.
        """
        # Check if recovery is allowed
        if issue.requires_gardener_approval:
            return RecoveryResult(
                success=False,
                reason="GARDENER_APPROVAL_REQUIRED",
                action="ESCALATE_TO_GARDENER"
            )
        
        # Check if recovery would violate Layer 0
        if self._would_violate_layer_0(issue.proposed_recovery):
            return RecoveryResult(
                success=False,
                reason="LAYER_0_VIOLATION",
                action="HALT_AND_REPORT"
            )
        
        # Execute recovery
        recovery_actions = {
            IssueType.MASS_HEALTH_DECLINE: self._recover_mass_health,
            IssueType.SPAWN_STORM: self._recover_spawn_storm,
            IssueType.COHERENCE_COLLAPSE: self._recover_coherence,
            IssueType.RESOURCE_EXHAUSTION: self._recover_resources,
        }
        
        if issue.type in recovery_actions:
            return recovery_actions[issue.type](issue)
        
        return RecoveryResult(
            success=False,
            reason="UNKNOWN_ISSUE_TYPE",
            action="ESCALATE_TO_GARDENER"
        )
    
    def _recover_mass_health(self, issue: SystemIssue) -> RecoveryResult:
        """
        Recover from mass health decline.
        """
        # Identify affected capsules
        affected = [c for c in self.registry.get_all_active() 
                   if c.get_health().composite < 0.5]
        
        # Triage
        for capsule in affected:
            if capsule.get_health().composite < 0.3:
                # Critical - quarantine
                self.quarantine.quarantine_immediate(capsule.id, "MASS_HEALTH_RECOVERY")
            else:
                # Degraded - medical attention
                self.medical.schedule_treatment(capsule.id, priority="HIGH")
        
        # Reduce system load
        self.rag.enter_conservation_mode()
        self.spawn_controller.pause_non_essential_spawns()
        
        return RecoveryResult(
            success=True,
            reason="RECOVERY_INITIATED",
            affected_count=len(affected),
            action="MONITOR_AND_REPORT"
        )
```

---

## 6. Configuration

```yaml
# asg_config.yaml
liveness:
  pulse_interval: 100          # Ticks between required pulses
  grace_period: 10             # Extra ticks before quarantine
  max_missed_pulses: 2         # Termination threshold
  signature_algorithm: "ed25519"

spawn:
  base_limits:
    low_stress: 50
    medium_stress: 20
    high_stress: 5
    critical_stress: 2
  min_parent_health: 0.65
  max_lineage_depth: 10
  min_sci: 0.70

quarantine:
  immediate_triggers:
    - "GENESIS_MISMATCH"
    - "SIGNATURE_INVALID"
    - "CONSTITUTIONAL_VIOLATION"
  investigation_triggers:
    - "STALE_TICK"
    - "HEALTH_CRITICAL"
    - "ANOMALY_DETECTED"

recovery:
  autonomous_enabled: true
  gardener_escalation_threshold: 0.3  # System health
  layer_0_override: false             # NEVER
```

---

## 7. Integration Points

| Component | Integration |
|-----------|-------------|
| **Layer 0 (Vault)** | Genesis verification, signature validation |
| **Reflex Engine** | Pulse processing (<10ms) |
| **Medical Suite** | Quarantine referrals, treatment scheduling |
| **Sandbox Framework** | Quarantine routing (Level 3) |
| **Resource Governor** | Spawn resource allocation |
| **d-CTM** | All events logged |

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Liveness Detection** | Missing pulse detected within PULSE_INTERVAL + GRACE_PERIOD |
| **Ghost Rejection** | 100% of genesis mismatches quarantined |
| **Spawn Governance** | S1-S6 enforced on every spawn |
| **Quarantine Enforcement** | <10ms from decision to isolation |
| **Recovery Autonomy** | Self-healing without violating Layer 0 |

---

## References

- Volume I: Layer 0 Foundation
- Appendix Q: Resource Allocation Governor
- Appendix K++: Medical Suite
- Appendix R: Sandbox Framework

---

*The heartbeat never stops. Every pulse proves life. Missing pulse proves death.*
