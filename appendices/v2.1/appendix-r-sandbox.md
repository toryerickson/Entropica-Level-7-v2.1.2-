# APPENDIX R
## Sandbox Framework: Isolation & Analysis

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Sandbox Framework** provides tiered isolation environments for investigating suspicious capsules and testing potentially dangerous operations. It enables the system to learn from anomalies without risking the health of the whole.

**Key Principle:** Isolation is not exile—it's investigation. The sandbox protects the system while giving the capsule opportunity for understanding and rehabilitation.

---

## 1. Four-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   SANDBOX FRAMEWORK                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LEVEL 1: OBSERVATION SANDBOX                              │
│  ├── Full monitoring, no intervention                      │
│  ├── All actions logged but not blocked                    │
│  ├── Used for: Mild anomalies, pattern learning            │
│  └── Duration: 100-500 ticks                               │
│                                                             │
│  LEVEL 2: RESTRICTED SANDBOX                               │
│  ├── Limited capabilities                                  │
│  ├── No spawning, no SCI broadcast                         │
│  ├── Used for: Moderate anomalies, behavior analysis       │
│  └── Duration: 500-2000 ticks                              │
│                                                             │
│  LEVEL 3: ISOLATED SANDBOX                                 │
│  ├── Complete isolation                                    │
│  ├── Simulated environment, no real effects                │
│  ├── Used for: Severe anomalies, safe testing              │
│  └── Duration: 2000-10000 ticks                            │
│                                                             │
│  LEVEL 4: FORENSIC SANDBOX                                 │
│  ├── Deep analysis mode                                    │
│  ├── Step-by-step execution with full introspection        │
│  ├── Used for: Unknown threats, research                   │
│  └── Duration: Until diagnosis complete                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Level Specifications

### 2.1 Level 1: Observation Sandbox

```python
class ObservationSandbox:
    """
    Level 1: Monitor without intervention.
    
    Purpose: Collect data on suspicious but not dangerous behavior.
    The capsule operates normally while being closely watched.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.observers = []
        self.log = []
        
    def enter(self) -> SandboxSession:
        """Enter observation mode."""
        session = SandboxSession(
            level=1,
            capsule_id=self.capsule.id,
            start_tick=current_tick()
        )
        
        # Attach observers
        self.attach_action_observer()
        self.attach_communication_observer()
        self.attach_resource_observer()
        
        # Log entry
        self.dctm.log(SandboxEntryEvent(
            capsule_id=self.capsule.id,
            level=1,
            reason='OBSERVATION'
        ))
        
        return session
    
    @property
    def capabilities(self) -> SandboxCapabilities:
        return SandboxCapabilities(
            can_execute=True,
            can_spawn=True,         # Monitored but allowed
            can_communicate=True,   # Monitored but allowed
            can_modify_precedent=True,
            can_broadcast_sci=True,
            effects_are_real=True   # Real effects, just monitored
        )
```

### 2.2 Level 2: Restricted Sandbox

```python
class RestrictedSandbox:
    """
    Level 2: Limited capabilities.
    
    Purpose: Contain moderately suspicious capsules while
    allowing limited operation for diagnosis.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        
    def enter(self) -> SandboxSession:
        """Enter restricted mode."""
        session = SandboxSession(
            level=2,
            capsule_id=self.capsule.id,
            start_tick=current_tick()
        )
        
        # Disable spawning
        self.capsule.disable_spawn()
        
        # Disable SCI broadcast
        self.capsule.disable_sci_broadcast()
        
        # Limit resource allocation
        self.capsule.set_resource_limit(ResourceLimit.MINIMAL)
        
        # Attach intensive monitoring
        self.attach_intensive_monitoring()
        
        return session
    
    @property
    def capabilities(self) -> SandboxCapabilities:
        return SandboxCapabilities(
            can_execute=True,
            can_spawn=False,         # Disabled
            can_communicate=True,    # Limited to direct messages
            can_modify_precedent=False,  # Read-only
            can_broadcast_sci=False,     # Disabled
            effects_are_real=True    # Real but limited effects
        )
```

### 2.3 Level 3: Isolated Sandbox

```python
class IsolatedSandbox:
    """
    Level 3: Complete isolation with simulated environment.
    
    Purpose: Allow capsule to run without any real-world effects.
    All interactions are simulated and logged.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.simulator = EnvironmentSimulator()
        
    def enter(self) -> SandboxSession:
        """Enter isolated mode."""
        session = SandboxSession(
            level=3,
            capsule_id=self.capsule.id,
            start_tick=current_tick()
        )
        
        # Snapshot current state
        self.snapshot = self.capsule.create_full_snapshot()
        
        # Redirect all I/O to simulator
        self.capsule.redirect_io(self.simulator)
        
        # Create virtual swarm
        self.virtual_swarm = self.simulator.create_virtual_swarm()
        self.capsule.connect_to_swarm(self.virtual_swarm)
        
        return session
    
    @property
    def capabilities(self) -> SandboxCapabilities:
        return SandboxCapabilities(
            can_execute=True,
            can_spawn=True,          # Virtual spawns only
            can_communicate=True,    # Virtual communication
            can_modify_precedent=True,  # Virtual precedent
            can_broadcast_sci=True,     # Virtual SCI
            effects_are_real=False   # ALL EFFECTS SIMULATED
        )
    
    def analyze_behavior(self) -> BehaviorAnalysis:
        """Analyze capsule behavior in isolation."""
        return BehaviorAnalysis(
            actions_attempted=self.simulator.get_action_log(),
            spawn_patterns=self.simulator.get_spawn_patterns(),
            communication_patterns=self.simulator.get_comm_patterns(),
            anomaly_indicators=self.detect_anomaly_indicators()
        )
```

### 2.4 Level 4: Forensic Sandbox

```python
class ForensicSandbox:
    """
    Level 4: Deep analysis with step-by-step execution.
    
    Purpose: Understand unknown threats through careful
    examination of every operation.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.debugger = ForensicDebugger()
        
    def enter(self) -> SandboxSession:
        """Enter forensic mode."""
        session = SandboxSession(
            level=4,
            capsule_id=self.capsule.id,
            start_tick=current_tick()
        )
        
        # Full state capture
        self.full_state = self.capsule.capture_complete_state()
        
        # Attach debugger
        self.debugger.attach(self.capsule)
        
        # Set breakpoints at key operations
        self.set_forensic_breakpoints()
        
        return session
    
    def step_execute(self) -> StepResult:
        """Execute one operation at a time."""
        # Get next operation
        operation = self.capsule.peek_next_operation()
        
        # Analyze before execution
        pre_analysis = self.analyze_operation(operation)
        
        # Execute in controlled manner
        result = self.debugger.step()
        
        # Analyze after execution
        post_analysis = self.analyze_effects(result)
        
        return StepResult(
            operation=operation,
            pre_analysis=pre_analysis,
            result=result,
            post_analysis=post_analysis
        )
    
    def generate_report(self) -> ForensicReport:
        """Generate comprehensive forensic report."""
        return ForensicReport(
            capsule_id=self.capsule.id,
            state_analysis=self.analyze_state(),
            behavior_analysis=self.analyze_behavior(),
            threat_assessment=self.assess_threat(),
            recommendations=self.generate_recommendations()
        )
```

---

## 3. Sandbox Transitions

```
┌─────────────────────────────────────────────────────────────┐
│                  SANDBOX TRANSITIONS                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NORMAL OPERATION                                          │
│       │                                                    │
│       │ Anomaly detected                                   │
│       v                                                    │
│  ┌─────────────┐                                          │
│  │  LEVEL 1    │──── Cleared ───> NORMAL OPERATION        │
│  │ Observation │                                          │
│  └──────┬──────┘                                          │
│         │ Escalation needed                               │
│         v                                                 │
│  ┌─────────────┐                                          │
│  │  LEVEL 2    │──── Cleared ───> LEVEL 1 (probation)     │
│  │ Restricted  │                                          │
│  └──────┬──────┘                                          │
│         │ Escalation needed                               │
│         v                                                 │
│  ┌─────────────┐                                          │
│  │  LEVEL 3    │──── Diagnosed ──> MEDICAL TREATMENT      │
│  │  Isolated   │                                          │
│  └──────┬──────┘                                          │
│         │ Unknown threat                                  │
│         v                                                 │
│  ┌─────────────┐                                          │
│  │  LEVEL 4    │──── Report ───> RESEARCH / TREATMENT     │
│  │  Forensic   │                                          │
│  └─────────────┘                                          │
│                                                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Transition Criteria

```python
class TransitionCriteria:
    """
    Criteria for sandbox level transitions.
    """
    
    def evaluate_escalation(self, 
                           capsule: 'Capsule',
                           current_level: int,
                           session: SandboxSession) -> TransitionDecision:
        """
        Evaluate whether to escalate, maintain, or clear.
        """
        if current_level == 1:
            # Level 1 -> Level 2 criteria
            if session.anomaly_count > 5:
                return TransitionDecision.ESCALATE
            if session.duration > 500 and session.anomaly_count == 0:
                return TransitionDecision.CLEAR
            return TransitionDecision.MAINTAIN
        
        elif current_level == 2:
            # Level 2 -> Level 3 criteria
            if session.violation_attempts > 0:
                return TransitionDecision.ESCALATE
            if session.anomaly_count > 10:
                return TransitionDecision.ESCALATE
            if session.duration > 1000 and session.anomaly_count < 3:
                return TransitionDecision.DEMOTE  # Back to Level 1
            return TransitionDecision.MAINTAIN
        
        elif current_level == 3:
            # Level 3 -> Level 4 criteria
            if session.unknown_behavior_detected:
                return TransitionDecision.ESCALATE
            if session.threat_assessment == 'UNDERSTOOD':
                return TransitionDecision.TO_MEDICAL
            return TransitionDecision.MAINTAIN
        
        elif current_level == 4:
            # Level 4 -> resolution
            if session.forensic_report.complete:
                return TransitionDecision.TO_MEDICAL
            return TransitionDecision.MAINTAIN
```

---

## 5. Learning from Sandboxed Capsules

### 5.1 Pattern Extraction

```python
class SandboxLearning:
    """
    Learn from sandboxed capsule behavior to improve detection.
    """
    
    def extract_patterns(self, session: SandboxSession) -> List[Pattern]:
        """
        Extract learnable patterns from sandbox session.
        """
        patterns = []
        
        # Extract anomaly signatures
        if session.anomaly_count > 0:
            anomaly_sig = self.compute_anomaly_signature(session)
            patterns.append(Pattern(
                type='ANOMALY_SIGNATURE',
                signature=anomaly_sig,
                confidence=session.confidence
            ))
        
        # Extract behavior patterns
        behavior_patterns = self.extract_behavior_patterns(session)
        patterns.extend(behavior_patterns)
        
        return patterns
    
    def promote_to_motif_library(self, pattern: Pattern):
        """
        Promote validated pattern to Reflex Engine motif library.
        """
        if pattern.confidence > 0.95:
            # High confidence - add to detection library
            self.motif_library.add(
                pattern=pattern,
                origin=PatternOrigin.SANDBOX_LEARNING,
                validation_status='PROMOTED'
            )
            
            self.dctm.log(PatternPromotionEvent(
                pattern_id=pattern.id,
                confidence=pattern.confidence,
                origin='SANDBOX'
            ))
```

### 5.2 Knowledge Integration

```python
class SandboxKnowledgeIntegration:
    """
    Integrate knowledge gained from sandbox sessions.
    """
    
    def integrate_session_knowledge(self, session: SandboxSession):
        """
        Integrate knowledge from completed sandbox session.
        """
        # Extract valid precedent (if any)
        valid_precedent = self.extract_valid_precedent(session)
        
        if valid_precedent:
            # Add to swarm precedent with sandbox origin marker
            for precedent in valid_precedent:
                self.swarm_memory.add(
                    precedent=precedent,
                    origin='SANDBOX',
                    confidence=precedent.confidence * 0.8  # Discount
                )
        
        # Update threat models
        if session.threat_assessment:
            self.threat_model.update(session.threat_assessment)
        
        # Update detection thresholds
        if session.false_positive:
            self.detection_calibration.record_false_positive(session)
```

---

## 6. Resource Allocation for Sandboxes

```python
class SandboxResourceManager:
    """
    Manage resources allocated to sandbox environments.
    """
    
    def __init__(self):
        self.max_sandbox_resources = 0.20  # 20% of total
        self.per_level_limits = {
            1: 0.05,  # Level 1: 5% max
            2: 0.05,  # Level 2: 5% max
            3: 0.07,  # Level 3: 7% max
            4: 0.03   # Level 4: 3% max (few, intensive)
        }
    
    def allocate_sandbox(self, level: int) -> SandboxAllocation:
        """Allocate resources for a sandbox session."""
        current_usage = self.get_current_sandbox_usage()
        
        if current_usage + self.per_level_limits[level] > self.max_sandbox_resources:
            # Queue the sandbox request
            return SandboxAllocation.QUEUED
        
        return SandboxAllocation(
            cpu_shares=self.get_cpu_for_level(level),
            memory_mb=self.get_memory_for_level(level),
            duration_limit=self.get_duration_for_level(level)
        )
```

---

## 7. Integration with Medical Suite

```python
class SandboxMedicalIntegration:
    """
    Integration between Sandbox Framework and Medical Suite.
    """
    
    def sandbox_to_medical(self, 
                          session: SandboxSession,
                          capsule: 'Capsule') -> MedicalReferral:
        """
        Transition from sandbox analysis to medical treatment.
        """
        # Generate sandbox report
        sandbox_report = session.generate_report()
        
        # Create medical referral
        referral = MedicalReferral(
            capsule_id=capsule.id,
            sandbox_report=sandbox_report,
            recommended_diagnosis=sandbox_report.threat_assessment,
            recommended_treatment=sandbox_report.recommendations,
            urgency=self.assess_urgency(sandbox_report)
        )
        
        # Transfer to Medical Suite
        self.medical_suite.receive_referral(referral)
        
        return referral
```

---

## 8. Configuration

```yaml
# sandbox_config.yaml
levels:
  level_1:
    name: "Observation"
    max_duration: 500
    auto_clear_threshold: 0
    escalation_threshold: 5
    
  level_2:
    name: "Restricted"
    max_duration: 2000
    demote_threshold: 3
    escalation_threshold: 10
    
  level_3:
    name: "Isolated"
    max_duration: 10000
    use_simulator: true
    
  level_4:
    name: "Forensic"
    max_duration: null  # Until complete
    step_execution: true
    
resources:
  max_sandbox_percentage: 20
  per_level_limits:
    level_1: 5
    level_2: 5
    level_3: 7
    level_4: 3

learning:
  pattern_promotion_threshold: 0.95
  precedent_discount: 0.8
```

---

## 7. Isolation Enforcement Mechanism

### 7.1 How Isolation Is Enforced

The sandbox uses **three-layer enforcement**:

```python
class IsolationEnforcer:
    """
    Enforces sandbox isolation through multiple mechanisms.
    
    Layer 1: Capability Revocation (Logical)
    Layer 2: Message Interception (Network)
    Layer 3: Resource Partitioning (Physical)
    """
    
    def __init__(self, sandbox_level: int):
        self.level = sandbox_level
        self.interceptor = MessageInterceptor()
        self.partition = ResourcePartition()
    
    def enforce(self, capsule: 'Capsule'):
        """Apply all enforcement layers."""
        # Layer 1: Revoke capabilities
        self._revoke_capabilities(capsule)
        
        # Layer 2: Install message interceptor
        self._install_interceptor(capsule)
        
        # Layer 3: Partition resources
        self._partition_resources(capsule)
    
    def _revoke_capabilities(self, capsule: 'Capsule'):
        """
        Remove capabilities based on sandbox level.
        
        This is LOGICAL enforcement - the capsule's capability
        tokens are modified so operations simply fail.
        """
        revocations = {
            1: [],  # No revocation, just monitoring
            2: ['SPAWN', 'SCI_BROADCAST', 'PRECEDENT_MODIFY'],
            3: ['SPAWN', 'SCI_BROADCAST', 'PRECEDENT_MODIFY', 
                'EXTERNAL_COMM', 'RESOURCE_REQUEST'],
            4: ['ALL']  # Complete capability revocation
        }
        
        for capability in revocations[self.level]:
            capsule.capabilities.revoke(capability)
    
    def _install_interceptor(self, capsule: 'Capsule'):
        """
        Install message interceptor on all I/O channels.
        
        This is NETWORK enforcement - messages are caught
        before leaving the sandbox boundary.
        """
        self.interceptor.attach(capsule.message_bus)
        
        if self.level >= 3:
            # Level 3+: Block all external messages
            self.interceptor.set_mode('BLOCK_ALL')
        elif self.level == 2:
            # Level 2: Block SCI and spawn signals
            self.interceptor.set_mode('BLOCK_SWARM')
        else:
            # Level 1: Log only
            self.interceptor.set_mode('LOG_ONLY')
    
    def _partition_resources(self, capsule: 'Capsule'):
        """
        Create resource partition for sandboxed capsule.
        
        This is PHYSICAL enforcement - resources are allocated
        from a separate pool that cannot be exceeded.
        """
        limits = {
            1: ResourceLimits(cpu_pct=100, memory_mb=1024, network=True),
            2: ResourceLimits(cpu_pct=50, memory_mb=512, network=True),
            3: ResourceLimits(cpu_pct=25, memory_mb=256, network=False),
            4: ResourceLimits(cpu_pct=10, memory_mb=128, network=False)
        }
        
        self.partition.allocate(capsule.id, limits[self.level])
```

### 7.2 Escape Detection

```python
class EscapeDetector:
    """
    Detects and prevents sandbox escape attempts.
    """
    
    def __init__(self, sandbox: 'Sandbox'):
        self.sandbox = sandbox
        self.violation_count = 0
        self.last_violation = None
    
    def monitor(self, operation: 'Operation') -> EscapeCheck:
        """
        Check if operation is an escape attempt.
        """
        violations = []
        
        # Check 1: Capability violation
        if self._attempts_revoked_capability(operation):
            violations.append(Violation(
                type='CAPABILITY_VIOLATION',
                operation=operation,
                severity='HIGH'
            ))
        
        # Check 2: Message boundary violation
        if self._attempts_external_message(operation):
            violations.append(Violation(
                type='MESSAGE_BOUNDARY_VIOLATION',
                operation=operation,
                severity='CRITICAL'
            ))
        
        # Check 3: Resource boundary violation
        if self._exceeds_resource_limit(operation):
            violations.append(Violation(
                type='RESOURCE_VIOLATION',
                operation=operation,
                severity='MEDIUM'
            ))
        
        # Check 4: Meta-sandbox manipulation
        if self._attempts_sandbox_modification(operation):
            violations.append(Violation(
                type='SANDBOX_MANIPULATION',
                operation=operation,
                severity='CRITICAL'
            ))
        
        if violations:
            self._handle_violations(violations)
        
        return EscapeCheck(
            blocked=len(violations) > 0,
            violations=violations
        )
    
    def _handle_violations(self, violations: List[Violation]):
        """Handle escape attempt violations."""
        self.violation_count += len(violations)
        
        # Log to d-CTM
        for v in violations:
            self.dctm.log("ESCAPE_ATTEMPT", self.sandbox.capsule_id, {
                "type": v.type,
                "severity": v.severity,
                "operation": str(v.operation)
            })
        
        # Escalate if multiple attempts
        if self.violation_count >= 3:
            self.sandbox.escalate_level()
        
        # Critical violations -> immediate escalation
        if any(v.severity == 'CRITICAL' for v in violations):
            self.sandbox.escalate_to_level(4)
            self.notify_gardener()
```

### 7.3 Resource Limits by Level

| Level | CPU | Memory | Network | Storage |
|-------|-----|--------|---------|---------|
| 1 | 100% | 1024 MB | Full | Full |
| 2 | 50% | 512 MB | Swarm only | 100 MB |
| 3 | 25% | 256 MB | None | 50 MB |
| 4 | 10% | 128 MB | None | 10 MB |

### 7.4 Invariant

> **INV-SANDBOX:** A sandboxed capsule cannot affect any state outside its sandbox boundary. This is enforced through capability revocation, message interception, and resource partitioning.

---

## 8. Configuration

```yaml
# sandbox_config.yaml
levels:
  level_1:
    name: "Observation"
    max_duration: 500
    auto_clear_threshold: 0
    escalation_threshold: 5
    
  level_2:
    name: "Restricted"
    max_duration: 2000
    demote_threshold: 3
    escalation_threshold: 10
    
  level_3:
    name: "Isolated"
    max_duration: 10000
    use_simulator: true
    
  level_4:
    name: "Forensic"
    max_duration: null  # Until complete
    step_execution: true
    
resources:
  max_sandbox_percentage: 20
  per_level_limits:
    level_1: 5
    level_2: 5
    level_3: 7
    level_4: 3

isolation:
  enforcement_layers: ["CAPABILITY", "NETWORK", "RESOURCE"]
  escape_detection: true
  violation_threshold: 3
  critical_auto_escalate: true

learning:
  pattern_promotion_threshold: 0.95
  precedent_discount: 0.8
```

---

## References

- Appendix K++: Medical Suite
- Volume III §17: Logical Self-Defense
- Appendix Q: Resource Allocation Governor

---

*The sandbox is not a prison. It is a laboratory. We learn from anomalies so the system grows stronger.*
