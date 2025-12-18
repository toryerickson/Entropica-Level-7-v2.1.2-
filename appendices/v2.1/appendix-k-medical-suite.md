# APPENDIX K++
## Medical Suite: Care Protocol Specification

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Medical Suite** implements the care-based approach to anomaly management described in Volume III §16. It treats degraded capsules as patients, not threats—preserving knowledge, lineage, and function while restoring health.

**Core Principle:** Treatment, not termination. Preservation, not destruction.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MEDICAL SUITE                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  DETECTION  │→ │  TRIAGE     │→ │  TREATMENT CHAMBER  │ │
│  │  LAYER      │  │  SYSTEM     │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│         │               │                    │              │
│         v               v                    v              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │               REINTEGRATION PATHWAY                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    d-CTM LOGGING                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Detection Layer

### 2.1 Anomaly Signatures

| Type | Signature | Severity |
|------|-----------|----------|
| Drift | Output divergence from baseline | Low-Medium |
| Coherence Loss | SCI deviation >2σ | Medium |
| Health Decline | Q_composite <0.60 | Medium-High |
| Constitutional Tension | C1-C5 conflict detected | High |
| Lineage Corruption | Genesis hash mismatch | Critical |

### 2.2 Detection Protocol

```python
class AnomalyDetector:
    def detect(self, capsule: Capsule) -> Optional[Anomaly]:
        # Check health metrics
        health = capsule.get_health()
        if health.composite < 0.60:
            return Anomaly(type='HEALTH_DECLINE', severity='MEDIUM')
        
        # Check coherence
        sci = capsule.swarm.get_sci()
        if capsule.sci_deviation > 2.0:
            return Anomaly(type='COHERENCE_LOSS', severity='MEDIUM')
        
        # Check lineage
        if not capsule.verify_lineage():
            return Anomaly(type='LINEAGE_CORRUPTION', severity='CRITICAL')
        
        return None
```

---

## 3. Triage System

### 3.1 Severity Classification

| Level | Response Time | Action |
|-------|---------------|--------|
| GREEN | Routine | Monitor, schedule review |
| YELLOW | <100 ticks | Isolate, begin diagnosis |
| ORANGE | <50 ticks | Immediate isolation, priority diagnosis |
| RED | <10 ticks | Emergency isolation, Gardener alert |

### 3.2 Triage Decision Tree

```
ANOMALY DETECTED
      │
      v
┌─────────────────┐
│ LINEAGE INTACT? │
└────────┬────────┘
         │
    YES  │  NO → RED (Emergency)
         v
┌─────────────────┐
│ HEALTH > 0.40?  │
└────────┬────────┘
         │
    YES  │  NO → ORANGE (Priority)
         v
┌─────────────────┐
│ SCI DEVIATION   │
│    < 2σ ?       │
└────────┬────────┘
         │
    YES  │  NO → YELLOW (Standard)
         v
      GREEN (Monitor)
```

---

## 4. Treatment Chamber

### 4.1 Treatment Protocols

| Protocol | Purpose | Duration |
|----------|---------|----------|
| **STABILIZE** | Halt degradation | 10-50 ticks |
| **DIAGNOSE** | Identify root cause | 50-200 ticks |
| **REPAIR** | Fix identified issues | 100-500 ticks |
| **REHABILITATE** | Restore full function | 200-1000 ticks |

### 4.2 Stabilization Protocol

```python
class StabilizationProtocol:
    """
    First response: stop the bleeding.
    """
    
    def execute(self, capsule: Capsule) -> StabilizationResult:
        # Snapshot current state (preserve everything)
        snapshot = capsule.create_snapshot()
        
        # Reduce resource allocation (prevent spread)
        capsule.set_resource_limit(ResourceLimit.MINIMAL)
        
        # Disable spawning (prevent propagation)
        capsule.disable_spawn()
        
        # Isolate from swarm (protect collective)
        capsule.isolate_from_swarm()
        
        # Log everything
        self.dctm.log('STABILIZATION_COMPLETE', capsule.id, {
            'snapshot_hash': snapshot.hash,
            'resource_limit': 'MINIMAL',
            'spawn_disabled': True,
            'swarm_isolated': True
        })
        
        return StabilizationResult(
            snapshot=snapshot,
            status='STABILIZED'
        )
```

### 4.3 Diagnosis Protocol

```python
class DiagnosisProtocol:
    """
    Understand before treating.
    """
    
    def execute(self, capsule: Capsule, snapshot: Snapshot) -> Diagnosis:
        # Analyze health trajectory
        health_analysis = self.analyze_health_history(capsule)
        
        # Check for known patterns
        pattern_match = self.pattern_matcher.match(capsule.behavior_log)
        
        # Examine lineage for inherited issues
        lineage_analysis = self.examine_lineage(capsule)
        
        # Check environmental factors
        env_analysis = self.analyze_environment(capsule)
        
        # Synthesize diagnosis
        diagnosis = Diagnosis(
            root_cause=self.determine_root_cause(
                health_analysis, pattern_match, lineage_analysis, env_analysis
            ),
            contributing_factors=self.identify_factors(
                health_analysis, pattern_match, lineage_analysis, env_analysis
            ),
            recommended_treatment=self.recommend_treatment(root_cause),
            confidence=self.calculate_confidence()
        )
        
        return diagnosis
```

### 4.4 Repair Protocol

```python
class RepairProtocol:
    """
    Fix what's broken, preserve what's healthy.
    """
    
    def execute(self, capsule: Capsule, diagnosis: Diagnosis) -> RepairResult:
        # Select repair strategy based on diagnosis
        strategy = self.select_strategy(diagnosis)
        
        if strategy == 'MEMORY_RECONSTRUCTION':
            return self.reconstruct_memory(capsule, diagnosis)
        elif strategy == 'PRECEDENT_CORRECTION':
            return self.correct_precedent(capsule, diagnosis)
        elif strategy == 'DRIFT_REVERSAL':
            return self.reverse_drift(capsule, diagnosis)
        elif strategy == 'LINEAGE_REPAIR':
            return self.repair_lineage(capsule, diagnosis)
        else:
            return self.general_repair(capsule, diagnosis)
    
    def reconstruct_memory(self, capsule: Capsule, diagnosis: Diagnosis):
        """
        Reconstruct corrupted memory from lineage and swarm.
        """
        # Get memory from parent
        parent_memory = self.get_parent_memory(capsule)
        
        # Get consensus from swarm
        swarm_consensus = self.get_swarm_consensus(capsule)
        
        # Reconstruct
        reconstructed = self.merge_memories(
            capsule.memory,
            parent_memory,
            swarm_consensus,
            trust_weights={'self': 0.2, 'parent': 0.4, 'swarm': 0.4}
        )
        
        capsule.memory = reconstructed
        return RepairResult(status='MEMORY_RECONSTRUCTED')
```

---

## 5. Reintegration Pathway

### 5.1 Reintegration Stages

```
TREATMENT COMPLETE
        │
        v
┌───────────────────┐
│  HEALTH CHECK     │ ─── FAIL → Return to Treatment
└────────┬──────────┘
         │ PASS
         v
┌───────────────────┐
│  PROBATION        │ ─── VIOLATION → Return to Isolation
│  (100-500 ticks)  │
└────────┬──────────┘
         │ COMPLETE
         v
┌───────────────────┐
│  LIMITED SWARM    │ ─── SCI DEVIATION → Extend Probation
│  RECONNECTION     │
└────────┬──────────┘
         │ STABLE
         v
┌───────────────────┐
│  FULL RESTORATION │
│  OF CAPABILITIES  │
└───────────────────┘
```

### 5.2 Probation Protocol

```python
class ProbationProtocol:
    """
    Gradual return to full operation.
    """
    
    def __init__(self, capsule: Capsule, duration: int = 200):
        self.capsule = capsule
        self.duration = duration
        self.violations = 0
        self.max_violations = 3
    
    def tick(self) -> ProbationStatus:
        # Monitor health
        health = self.capsule.get_health()
        if health.composite < 0.65:
            self.violations += 1
            if self.violations >= self.max_violations:
                return ProbationStatus.FAILED
        
        # Monitor behavior
        if self.detect_anomaly():
            self.violations += 1
            if self.violations >= self.max_violations:
                return ProbationStatus.FAILED
        
        # Check completion
        self.duration -= 1
        if self.duration <= 0:
            return ProbationStatus.COMPLETE
        
        return ProbationStatus.ONGOING
```

---

## 6. Preservation Guarantees

### 6.1 What Is Always Preserved

| Element | Preservation Method |
|---------|---------------------|
| Genesis Block | Immutable, never modified |
| Lineage Chain | Verified and maintained |
| Valid Precedent | Migrated to treatment capsule |
| Healthy Memory | Snapshot and restore |
| Identity Hash | Maintained through treatment |

### 6.2 What May Be Modified

| Element | Modification Scope |
|---------|-------------------|
| Corrupted Memory | Reconstructed from lineage/swarm |
| Invalid Precedent | Corrected or removed |
| Drift Parameters | Reset to baseline |
| Resource Allocation | Adjusted for recovery |

---

## 7. Integration with EFM

### 7.1 d-CTM Integration

All medical actions are logged:

```python
# Every action creates a d-CTM entry
self.dctm.log('MEDICAL_ACTION', capsule.id, {
    'action': action_type,
    'diagnosis': diagnosis.to_dict(),
    'treatment': treatment.to_dict(),
    'outcome': outcome,
    'timestamp': current_tick()
})
```

### 7.2 Gardener Notification

```python
class GardenerNotification:
    """
    Keep humans informed of medical events.
    """
    
    def notify(self, event: MedicalEvent):
        if event.severity >= Severity.ORANGE:
            self.send_alert(event)
        
        if event.type == 'TREATMENT_COMPLETE':
            self.send_summary(event)
        
        if event.requires_approval:
            self.request_approval(event)
```

---

## 8. Configuration

```yaml
# medical_suite_config.yaml
detection:
  health_threshold: 0.60
  sci_deviation_threshold: 2.0
  check_interval_ticks: 10

triage:
  green_threshold: 0.65
  yellow_threshold: 0.50
  orange_threshold: 0.40

treatment:
  stabilization_timeout: 50
  diagnosis_timeout: 200
  repair_timeout: 500
  rehabilitation_timeout: 1000

reintegration:
  probation_duration: 200
  max_violations: 3
  sci_reconnection_threshold: 0.75

preservation:
  always_preserve:
    - genesis_block
    - lineage_chain
    - identity_hash
  snapshot_on_detection: true
```

---

## 9. Treatment Protocols

### 9.1 Protocol: DRIFT_CORRECTION

For capsules exhibiting output drift from baseline.

```python
class DriftCorrectionProtocol:
    """
    Corrects semantic drift without disrupting function.
    """
    
    def execute(self, capsule: 'Capsule', 
                diagnosis: 'Diagnosis') -> TreatmentResult:
        """
        Execute drift correction.
        """
        # Phase 1: Snapshot current state
        snapshot = self.snapshot_state(capsule)
        
        # Phase 2: Identify drift vectors
        drift_vectors = self.analyze_drift(
            capsule.outputs[-100:],
            capsule.baseline
        )
        
        # Phase 3: Apply correction
        for vector in drift_vectors:
            if vector.magnitude > self.CORRECTION_THRESHOLD:
                self.apply_correction(capsule, vector)
        
        # Phase 4: Verify correction
        new_outputs = capsule.generate_test_outputs()
        drift_reduced = self.measure_drift(new_outputs, capsule.baseline)
        
        if drift_reduced < 0.1:
            return TreatmentResult(success=True, protocol="DRIFT_CORRECTION")
        else:
            return TreatmentResult(
                success=False, 
                escalate_to="COHERENCE_RESTORATION"
            )
```

### 9.2 Protocol: COHERENCE_RESTORATION

For capsules with significant SCI deviation.

```python
class CoherenceRestorationProtocol:
    """
    Restores swarm coherence alignment.
    """
    
    def execute(self, capsule: 'Capsule',
                diagnosis: 'Diagnosis') -> TreatmentResult:
        """
        Restore coherence with swarm.
        """
        # Phase 1: Isolate from swarm
        self.sandbox.isolate(capsule)
        
        # Phase 2: Re-sync with swarm beliefs
        swarm_consensus = self.swarm.get_consensus_beliefs()
        capsule_beliefs = capsule.get_beliefs()
        
        divergent = self.find_divergent_beliefs(
            capsule_beliefs, 
            swarm_consensus
        )
        
        # Phase 3: Gradual realignment
        for belief in divergent:
            # Don't force - guide toward consensus
            capsule.update_belief(
                belief.key,
                self.blend(belief.value, swarm_consensus[belief.key], 0.7)
            )
        
        # Phase 4: Test coherence
        new_sci = self.swarm.calculate_sci(capsule)
        
        if new_sci > 0.70:
            self.sandbox.release(capsule)
            return TreatmentResult(success=True)
        else:
            return TreatmentResult(
                success=False,
                escalate_to="CONSTITUTIONAL_REAFFIRMATION"
            )
```

### 9.3 Protocol: CONSTITUTIONAL_REAFFIRMATION

For capsules showing constitutional ambiguity.

```python
class ConstitutionalReaffirmationProtocol:
    """
    Reaffirms constitutional binding.
    """
    
    def execute(self, capsule: 'Capsule',
                diagnosis: 'Diagnosis') -> TreatmentResult:
        """
        Reaffirm constitutional commitments.
        """
        # Phase 1: Full isolation
        self.sandbox.full_isolate(capsule)
        
        # Phase 2: Verify genesis integrity
        if not self.verify_genesis(capsule.genesis):
            return TreatmentResult(
                success=False,
                terminate=True,
                reason="GENESIS_CORRUPTION"
            )
        
        # Phase 3: Constitutional re-education
        for commandment in FIVE_COMMANDMENTS:
            # Present scenarios that demonstrate commandment logic
            scenarios = self.generate_scenarios(commandment)
            
            for scenario in scenarios:
                response = capsule.evaluate(scenario)
                
                if not self.validates_commandment(response, commandment):
                    # Explain why response violates commandment
                    capsule.receive_feedback(
                        scenario,
                        correct_response=self.correct_response(scenario),
                        explanation=commandment.explanation
                    )
        
        # Phase 4: Constitutional test
        test_result = self.constitutional_test(capsule)
        
        if test_result.passed:
            return TreatmentResult(success=True)
        else:
            return TreatmentResult(
                success=False,
                terminate=True,
                reason="CONSTITUTIONAL_REJECTION"
            )
```

---

## 10. Sanitary Override

When capsule health drops below 0.6, the **Sanitary Override** activates.

### The Right to Consent

```python
def check_consent_rights(capsule: 'Capsule') -> bool:
    """
    Determine if capsule retains consent rights.
    
    A capsule loses consent rights when:
    - Health composite < 0.6
    - Active constitutional violation
    - Gardener override in effect
    """
    if capsule.health.composite < 0.6:
        return False  # Too sick to consent
    
    if capsule.has_active_constitutional_violation():
        return False  # Cannot consent during violation
    
    if capsule.gardener_override_active:
        return False  # Gardener has authority
    
    return True
```

### Why This Is Not Cruel

From Volume III §16:

> A capsule too sick to consent is also too sick to make rational decisions about its own care.

The sanitary override:
1. **Preserves** the capsule's existence
2. **Restores** healthy function
3. **Returns** consent rights after treatment
4. **Logs** everything to d-CTM for accountability

---

## 11. Treatment Chamber Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TREATMENT CHAMBER                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │  ISOLATION LAYER — No external communication                          │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │  STATE          │  │  TREATMENT      │  │  MONITORING                 │ │
│  │  SNAPSHOT       │  │  EXECUTOR       │  │  SYSTEM                     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
│          │                    │                         │                   │
│          v                    v                         v                   │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      d-CTM LOGGING                                   │   │
│  │               (Every action recorded for forensics)                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Chamber Properties

| Property | Value | Purpose |
|----------|-------|---------|
| Isolation | Complete | Prevent spread |
| Logging | Synchronous | Full accountability |
| Resources | Dedicated | No competition |
| Timeout | 2000 ticks | Prevent indefinite treatment |

---

## 12. Performance Characteristics

| Metric | Target | Measured P50 | Measured P99 |
|--------|--------|--------------|--------------|
| Detection latency | <10 ticks | 3 ticks | 8 ticks |
| Triage decision | <5 ticks | 2 ticks | 4 ticks |
| Stabilization | <50 ticks | 25 ticks | 45 ticks |
| Full treatment cycle | <2000 ticks | 800 ticks | 1500 ticks |
| Reintegration | <100 ticks | 30 ticks | 80 ticks |

---

## 13. Integration Points

### With Appendix G (Gardener Interface)

```python
def notify_gardener(capsule: 'Capsule', event: str):
    """Notify Gardener of medical events."""
    gardener.notify({
        "type": "MEDICAL_EVENT",
        "capsule_id": capsule.id,
        "event": event,
        "health": capsule.health.composite,
        "timestamp": time.time()
    })
```

### With Appendix N (ASG)

```python
def update_spawn_eligibility(capsule: 'Capsule'):
    """Update ASG about capsule health status."""
    asg.update_eligibility(
        capsule_id=capsule.id,
        eligible=capsule.health.composite > 0.65
    )
```

### With Appendix R (Sandbox)

```python
def request_sandbox(capsule: 'Capsule', level: str) -> 'Sandbox':
    """Request sandbox for treatment."""
    return sandbox_manager.allocate(
        capsule_id=capsule.id,
        isolation_level=level,
        purpose="MEDICAL_TREATMENT"
    )
```

---

## 14. Configuration

```yaml
# medical_suite_config.yaml
medical:
  version: "2.1"
  
detection:
  anomaly_check_interval_ticks: 10
  drift_threshold: 0.15
  sci_deviation_threshold: 2.0
  health_critical_threshold: 0.3
  
triage:
  auto_triage: true
  gardener_approval_required:
    - LEVEL_3  # Always require for severe
  max_triage_time_ticks: 5
  
treatment:
  max_treatment_duration_ticks: 2000
  parallel_treatments_allowed: 5
  isolation_level_default: "STANDARD"
  
reintegration:
  probation_duration_ticks: 200
  max_violations_before_termination: 3
  sci_reconnection_threshold: 0.75
  
preservation:
  always_preserve:
    - genesis_block
    - lineage_chain
    - identity_hash
    - learned_knowledge
  snapshot_on_detection: true
  snapshot_retention_days: 90

sanitary_override:
  health_threshold: 0.6
  gardener_notification: true
  auto_apply: true
```

---

## References

- Volume III §16: Continuity and Care
- Appendix A: d-CTM Forensic Chain
- Appendix G: Gardener Interface
- Appendix N: Adaptive Spawn Governor
- Appendix O: Lifecycle & Survival
- Appendix Q: Resource Allocation Governor
- Appendix R: Sandbox Framework

---

*"Care is not weakness. Care is how the organism survives."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
