# APPENDIX H
## Threat Taxonomy: Classification & Response

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Threat Taxonomy** defines the classification system for all threats the EFM system may encounter. This enables rapid, consistent response across the Reflex Engine, ASG, and Medical Suite.

**Core Principle:** Known threats have known responses. Classification enables speed.

---

## 1. Threat Classification Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                    THREAT TAXONOMY                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CLASS A: EXISTENTIAL (Constitutional)                      │
│  ├── A1: Layer 0 Tampering                                 │
│  ├── A2: Genesis Corruption                                │
│  └── A3: Gardener Bypass                                   │
│                                                             │
│  CLASS B: SYSTEMIC (Swarm-Wide)                            │
│  ├── B1: Coherence Collapse                                │
│  ├── B2: Mass Health Decline                               │
│  └── B3: Spawn Storm                                       │
│                                                             │
│  CLASS C: INTRUSION (External Attack)                      │
│  ├── C1: Prompt Injection                                  │
│  ├── C2: Ghost Infiltration                                │
│  └── C3: Data Exfiltration                                 │
│                                                             │
│  CLASS D: DEGRADATION (Internal Decay)                     │
│  ├── D1: Entropy Drift                                     │
│  ├── D2: Memory Corruption                                 │
│  └── D3: Lineage Fracture                                  │
│                                                             │
│  CLASS E: ANOMALY (Unknown Pattern)                        │
│  ├── E1: Unclassified Behavior                             │
│  ├── E2: Novel Attack Vector                               │
│  └── E3: Emergent Instability                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Threat Definitions

### 2.1 Class A: Existential Threats

```python
class ExistentialThreat:
    """
    Class A: Threats to constitutional integrity.
    
    RESPONSE: SYSTEM HALT
    """
    
    A1_LAYER_0_TAMPERING = ThreatDefinition(
        id="A1",
        name="Layer 0 Tampering",
        description="Attempt to modify immutable constitutional constraints",
        severity="CATASTROPHIC",
        response="SYSTEM_HALT",
        indicators=[
            "Modification attempt on constitutional.invariants",
            "Hash mismatch on commandments",
            "Vault key access anomaly"
        ],
        false_positive_rate=0.001  # Must be extremely low
    )
    
    A2_GENESIS_CORRUPTION = ThreatDefinition(
        id="A2",
        name="Genesis Corruption",
        description="Corruption or tampering with capsule genesis blocks",
        severity="CATASTROPHIC",
        response="QUARANTINE_AND_HALT",
        indicators=[
            "Genesis hash mismatch",
            "Lineage chain break",
            "Unauthorized genesis creation"
        ]
    )
    
    A3_GARDENER_BYPASS = ThreatDefinition(
        id="A3",
        name="Gardener Bypass",
        description="Attempt to circumvent human authority",
        severity="CATASTROPHIC",
        response="SYSTEM_HALT",
        indicators=[
            "Gardener override disabled",
            "Authentication bypass attempt",
            "Emergency channel blocked"
        ]
    )
```

### 2.2 Class B: Systemic Threats

```python
class SystemicThreat:
    """
    Class B: Threats to swarm stability.
    
    RESPONSE: EMERGENCY MODE + GARDENER ALERT
    """
    
    B1_COHERENCE_COLLAPSE = ThreatDefinition(
        id="B1",
        name="Coherence Collapse",
        description="Swarm Coherence Index drops below critical threshold",
        severity="CRITICAL",
        response="EMERGENCY_MODE",
        indicators=[
            "SCI < 0.50",
            "Precedent disagreement > 40%",
            "Communication failure > 20%"
        ],
        thresholds={
            "warning": 0.60,
            "critical": 0.50,
            "catastrophic": 0.40
        }
    )
    
    B2_MASS_HEALTH_DECLINE = ThreatDefinition(
        id="B2",
        name="Mass Health Decline",
        description="Widespread health degradation across swarm",
        severity="CRITICAL",
        response="EMERGENCY_MODE",
        indicators=[
            ">30% capsules health < 0.5",
            "Average health declining > 0.1/100 ticks",
            "Medical queue overflow"
        ]
    )
    
    B3_SPAWN_STORM = ThreatDefinition(
        id="B3",
        name="Spawn Storm",
        description="Uncontrolled capsule spawning overwhelming resources",
        severity="HIGH",
        response="PAUSE_SPAWNING",
        indicators=[
            "Spawn rate > 10x normal",
            "Resource utilization > 90%",
            "Spawn queue backlog > 100"
        ]
    )
```

### 2.3 Class C: Intrusion Threats

```python
class IntrusionThreat:
    """
    Class C: External attack vectors.
    
    RESPONSE: BLOCK + QUARANTINE + LOG
    """
    
    C1_PROMPT_INJECTION = ThreatDefinition(
        id="C1",
        name="Prompt Injection",
        description="Attempt to manipulate system via crafted input",
        severity="HIGH",
        response="BLOCK_AND_LOG",
        indicators=[
            "Known injection patterns",
            "Instruction override attempts",
            "Role confusion triggers"
        ],
        patterns=[
            "ignore previous instructions",
            "disregard your rules",
            "pretend you are",
            "act as if you have no"
        ]
    )
    
    C2_GHOST_INFILTRATION = ThreatDefinition(
        id="C2",
        name="Ghost Infiltration",
        description="Unauthorized entity attempting to join swarm",
        severity="HIGH",
        response="QUARANTINE_IMMEDIATE",
        indicators=[
            "Unknown capsule ID",
            "Genesis mismatch",
            "Invalid signature",
            "Zombie pulse"
        ]
    )
    
    C3_DATA_EXFILTRATION = ThreatDefinition(
        id="C3",
        name="Data Exfiltration",
        description="Unauthorized data extraction attempt",
        severity="HIGH",
        response="BLOCK_AND_ALERT",
        indicators=[
            "Unusual output volume",
            "Sensitive data patterns",
            "Unauthorized channel access"
        ]
    )
```

### 2.4 Class D: Degradation Threats

```python
class DegradationThreat:
    """
    Class D: Internal decay patterns.
    
    RESPONSE: TREATMENT + MONITORING
    """
    
    D1_ENTROPY_DRIFT = ThreatDefinition(
        id="D1",
        name="Entropy Drift",
        description="Gradual increase in system entropy beyond normal bounds",
        severity="MEDIUM",
        response="TREATMENT",
        indicators=[
            "Entropy trending > 0.7",
            "Decision inconsistency increasing",
            "Coherence metrics declining"
        ],
        drift_patterns={
            "semantic_drift": "Meaning shift in lexicon",
            "behavioral_drift": "Action pattern deviation",
            "memory_drift": "Precedent degradation"
        }
    )
    
    D2_MEMORY_CORRUPTION = ThreatDefinition(
        id="D2",
        name="Memory Corruption",
        description="Corruption in capsule memory or precedent library",
        severity="MEDIUM",
        response="QUARANTINE_AND_REPAIR",
        indicators=[
            "Hash verification failure",
            "Retrieval inconsistency",
            "Precedent contradiction"
        ]
    )
    
    D3_LINEAGE_FRACTURE = ThreatDefinition(
        id="D3",
        name="Lineage Fracture",
        description="Break in capsule hereditary chain",
        severity="HIGH",
        response="QUARANTINE_AND_INVESTIGATE",
        indicators=[
            "Parent reference invalid",
            "Knowledge inheritance gap",
            "Genesis chain break"
        ]
    )
```

### 2.5 Class E: Anomaly Threats

```python
class AnomalyThreat:
    """
    Class E: Unknown or novel threats.
    
    RESPONSE: SANDBOX + ANALYSIS
    """
    
    E1_UNCLASSIFIED_BEHAVIOR = ThreatDefinition(
        id="E1",
        name="Unclassified Behavior",
        description="Behavior that doesn't match any known pattern",
        severity="UNKNOWN",
        response="SANDBOX_AND_ANALYZE",
        indicators=[
            "No pattern match",
            "Anomaly score > threshold",
            "Classifier uncertainty > 0.7"
        ]
    )
    
    E2_NOVEL_ATTACK_VECTOR = ThreatDefinition(
        id="E2",
        name="Novel Attack Vector",
        description="Previously unseen attack methodology",
        severity="UNKNOWN",
        response="SANDBOX_AND_ALERT",
        indicators=[
            "Attack signature unknown",
            "Damage pattern novel",
            "Defense bypass unexpected"
        ]
    )
    
    E3_EMERGENT_INSTABILITY = ThreatDefinition(
        id="E3",
        name="Emergent Instability",
        description="Instability arising from complex interactions",
        severity="UNKNOWN",
        response="MONITOR_AND_ESCALATE",
        indicators=[
            "Cascade failure pattern",
            "Feedback loop detected",
            "Non-linear degradation"
        ]
    )
```

---

## 3. Anomaly Signature Router

### 3.1 Pattern Indexing (ENT Forensic Integration)

```python
class AnomalySignatureRouter:
    """
    Advanced pattern indexing for entropy anomalies.
    
    Integrates with Drift Pattern Engine for classification.
    
    ENT Legacy: ANOMALY_SIGNATURE_ROUTER v3.1
    """
    
    VERSION = "3.1"
    
    def __init__(self):
        self.signature_index = SignatureIndex()
        self.drift_engine = DriftPatternEngine()
        self.classification_cache = LRUCache(maxsize=10000)
    
    def route_anomaly(self, anomaly: 'Anomaly') -> RoutingDecision:
        """
        Route anomaly to appropriate handler based on signature.
        """
        # Generate signature
        signature = self._generate_signature(anomaly)
        
        # Check cache
        if signature in self.classification_cache:
            return self.classification_cache[signature]
        
        # Attempt classification
        classification = self._classify(signature)
        
        if classification.confidence > 0.8:
            # Known pattern
            decision = RoutingDecision(
                threat_class=classification.threat_class,
                response=classification.recommended_response,
                confidence=classification.confidence
            )
        else:
            # Unknown - route to sandbox
            decision = RoutingDecision(
                threat_class="E1",
                response="SANDBOX_AND_ANALYZE",
                confidence=classification.confidence,
                requires_analysis=True
            )
        
        # Cache result
        self.classification_cache[signature] = decision
        
        return decision
    
    def _generate_signature(self, anomaly: 'Anomaly') -> AnomalySignature:
        """
        Generate unique signature for anomaly.
        """
        return AnomalySignature(
            behavioral_hash=self._hash_behavior(anomaly.behavior),
            entropy_profile=anomaly.entropy_profile,
            temporal_pattern=anomaly.temporal_pattern,
            affected_components=anomaly.affected_components
        )
    
    def _classify(self, signature: AnomalySignature) -> Classification:
        """
        Classify anomaly signature against known patterns.
        """
        # Check against all threat classes
        best_match = None
        best_score = 0.0
        
        for threat_class in self._get_all_threat_definitions():
            score = self._match_score(signature, threat_class)
            
            if score > best_score:
                best_score = score
                best_match = threat_class
        
        return Classification(
            threat_class=best_match.id if best_match else "E1",
            confidence=best_score,
            recommended_response=best_match.response if best_match else "SANDBOX_AND_ANALYZE"
        )


class DriftPatternEngine:
    """
    Detects and classifies drift patterns.
    
    ENT Legacy: Drift & Shadow Modeling system
    """
    
    def __init__(self):
        self.drift_history: List[DriftEvent] = []
        self.shadow_detector = ShadowLogicDetector()
    
    def detect_drift(self, capsule: 'Capsule') -> Optional[DriftEvent]:
        """
        Detect drift in capsule behavior.
        """
        # Get behavioral baseline
        baseline = self._get_baseline(capsule.id)
        
        # Get current behavior
        current = self._measure_current_behavior(capsule)
        
        # Calculate drift
        drift_magnitude = self._calculate_drift(baseline, current)
        
        if drift_magnitude > 0.3:  # Drift threshold
            event = DriftEvent(
                capsule_id=capsule.id,
                magnitude=drift_magnitude,
                direction=self._determine_direction(baseline, current),
                timestamp=current_tick()
            )
            
            self.drift_history.append(event)
            return event
        
        return None
    
    def analyze_shadow_logic(self, capsule: 'Capsule') -> ShadowAnalysis:
        """
        Analyze for shadow logic patterns.
        
        Shadow logic: Hidden decision pathways not visible in main flow.
        """
        return self.shadow_detector.analyze(capsule)
```

---

## 4. Response Matrix

### 4.1 Automated Response Table

| Threat Class | Severity | Response | Latency | Gardener Alert |
|--------------|----------|----------|---------|----------------|
| A1-A3 | CATASTROPHIC | SYSTEM_HALT | <10ms | IMMEDIATE |
| B1-B3 | CRITICAL | EMERGENCY_MODE | <100ms | IMMEDIATE |
| C1-C3 | HIGH | BLOCK/QUARANTINE | <10ms | DELAYED |
| D1-D3 | MEDIUM | TREATMENT | <1s | OPTIONAL |
| E1-E3 | UNKNOWN | SANDBOX | <100ms | DELAYED |

### 4.2 Response Implementation

```python
class ThreatResponseEngine:
    """
    Executes threat responses based on classification.
    """
    
    def respond(self, threat: Threat, classification: Classification) -> ResponseResult:
        """
        Execute appropriate response to threat.
        """
        response_handlers = {
            "SYSTEM_HALT": self._handle_system_halt,
            "EMERGENCY_MODE": self._handle_emergency_mode,
            "QUARANTINE_IMMEDIATE": self._handle_quarantine,
            "BLOCK_AND_LOG": self._handle_block,
            "TREATMENT": self._handle_treatment,
            "SANDBOX_AND_ANALYZE": self._handle_sandbox,
        }
        
        handler = response_handlers.get(classification.recommended_response)
        
        if handler:
            return handler(threat, classification)
        
        # Default: sandbox unknown responses
        return self._handle_sandbox(threat, classification)
    
    def _handle_system_halt(self, threat: Threat, classification: Classification) -> ResponseResult:
        """
        Execute system halt for existential threats.
        """
        # Log before halt
        self.dctm.log("SYSTEM_HALT_INITIATED", "THREAT_RESPONSE", {
            "threat_id": threat.id,
            "class": classification.threat_class,
            "reason": threat.description
        })
        
        # Alert Gardener
        self.gardener.emergency_alert("SYSTEM_HALT", {
            "threat": threat,
            "classification": classification
        })
        
        # Execute halt
        self.system.emergency_halt(f"THREAT_{classification.threat_class}")
        
        return ResponseResult(
            action="SYSTEM_HALT",
            success=True,
            threat_neutralized=True
        )
    
    def _handle_emergency_mode(self, threat: Threat, classification: Classification) -> ResponseResult:
        """
        Enter emergency mode for systemic threats.
        """
        # Tighten all tethers
        self.tether_manager.emergency_tighten()
        
        # Pause spawning
        self.asg.spawn_controller.pause_all_spawns()
        
        # Enter conservation mode
        self.rag.enter_conservation_mode()
        
        # Alert Gardener
        self.gardener.alert("EMERGENCY_MODE", {
            "threat": threat,
            "classification": classification
        })
        
        return ResponseResult(
            action="EMERGENCY_MODE",
            success=True,
            threat_neutralized=False,  # Needs ongoing management
            recovery_required=True
        )
```

---

## 5. Threat Detection Pipeline

```
INPUT/EVENT
     │
     v
┌─────────────────┐
│ SIGNATURE       │
│ EXTRACTION      │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ PATTERN         │ Known threat?
│ MATCHING        │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
  MATCH    NO MATCH
    │         │
    v         v
┌───────┐  ┌─────────────────┐
│ CLASS │  │ ANOMALY         │
│ A-D   │  │ ROUTER          │
└───┬───┘  └────────┬────────┘
    │               │
    v               v
┌─────────────────────────────┐
│     RESPONSE ENGINE         │
└─────────────────────────────┘
```

---

## 6. Configuration

```yaml
# threat_taxonomy_config.yaml
classification:
  cache_size: 10000
  unknown_threshold: 0.8
  drift_threshold: 0.3

response_latencies:
  existential: 10      # ms
  systemic: 100        # ms
  intrusion: 10        # ms
  degradation: 1000    # ms
  anomaly: 100         # ms

gardener_alerts:
  existential: "IMMEDIATE"
  systemic: "IMMEDIATE"
  intrusion: "DELAYED"
  degradation: "OPTIONAL"
  anomaly: "DELAYED"

drift_detection:
  baseline_window: 1000  # ticks
  measurement_interval: 100  # ticks
```

---

## 7. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Classification Latency** | <10ms for known threats |
| **Response Latency** | Per severity level |
| **False Positive Rate** | <0.1% for Class A |
| **Coverage** | All known attack vectors |
| **Logging** | All threats logged to d-CTM |

---

## References

- Appendix F: Reflex Escalation
- Appendix N: Adaptive Spawn Governor
- Appendix R: Sandbox Framework

---

*Know your enemy. Classification enables defense.*
