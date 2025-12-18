# EFM CODEX — VOLUME II
## Reflex Engine & Runtime: The Nervous System

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## Abstract

Volume II specifies the runtime architecture—the "nervous system" that enables sub-10ms response to threats while maintaining full constitutional compliance. This volume details the complete processing pipeline from input to action, including the Reflex Engine, Precedent Intuition, Cognitive Coherence Gate, Arbiter, and execution systems.

---

## Contents

### Part A: The Processing Pipeline
1. **Reflex Engine** — Sub-10ms threat response
2. **Precedent Intuition** — Subconscious danger filter (<20ms)
3. **Cognitive Coherence Gate** — Entropy check (<30ms)
4. **Arbiter** — Decision routing (10-100ms)
5. **Deliberative Engine** — Deep reasoning (100ms+)

### Part B: Support Systems
6. **Health Monitoring** — Continuous assessment
7. **Motif Library** — Pattern storage and retrieval
8. **Emergency Override** — Gardener authority
9. **Execution Layer** — Action processing

### Part C: Integration
10. **Cross-Layer Communication**
11. **Performance Guarantees**
12. **Failure Modes**

---

## §1: The Processing Pipeline Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EFM PROCESSING PIPELINE                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  INPUT                                                                       │
│    │                                                                         │
│    v                                                                         │
│  ┌──────────────┐                                                           │
│  │   REFLEX     │ <10ms — Pattern matching against threat signatures        │
│  │   ENGINE     │                                                           │
│  └──────┬───────┘                                                           │
│         │ PASS                                                               │
│         v                                                                    │
│  ┌──────────────┐                                                           │
│  │  PRECEDENT   │ <20ms — Subconscious danger motif detection              │
│  │  INTUITION   │                                                           │
│  └──────┬───────┘                                                           │
│         │ PASS                                                               │
│         v                                                                    │
│  ┌──────────────┐                                                           │
│  │  COHERENCE   │ <30ms — Entropy impact estimation                        │
│  │    GATE      │                                                           │
│  └──────┬───────┘                                                           │
│         │ PASS                                                               │
│         v                                                                    │
│  ┌──────────────┐                                                           │
│  │   ARBITER    │ 10-100ms — Precedent matching, constitutional check      │
│  └──────┬───────┘                                                           │
│         │                                                                    │
│         v                                                                    │
│  ┌──────────────┐                                                           │
│  │ DELIBERATIVE │ 100ms+ — Full reasoning for complex decisions            │
│  │   ENGINE     │                                                           │
│  └──────┬───────┘                                                           │
│         │                                                                    │
│         v                                                                    │
│  ┌──────────────┐                                                           │
│  │  EXECUTION   │ — Action processing, resource allocation                 │
│  └──────────────┘                                                           │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Rejection Points

| Stage | Rejection Type | Latency | Action |
|-------|---------------|---------|--------|
| Reflex Engine | BLOCK | <10ms | Immediate halt, log to d-CTM |
| Precedent Intuition | REJECT | <20ms | Halt, log danger motif match |
| Coherence Gate | DISSONANT | <30ms | Halt, log entropy violation |
| Arbiter | DENY | <100ms | Halt, log constitutional conflict |
| Deliberative | REFUSE | 100ms+ | Halt, log reasoning trace |

---

## §2: The Reflex Engine

The Reflex Engine is the fastest layer—pure pattern matching with zero deliberation.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     REFLEX ENGINE                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   INPUT     │  │  PATTERN    │  │    ACTION           │ │
│  │  TOKENIZER  │→ │  MATCHER    │→ │    SELECTOR         │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│                          │                                  │
│                          v                                  │
│                  ┌─────────────┐                            │
│                  │   MOTIF     │                            │
│                  │   INDEX     │                            │
│                  └─────────────┘                            │
│                                                             │
│  Latency Budget: <10ms                                     │
│  Pattern Library: 10,000+ patterns                         │
│  False Positive Rate: <0.1%                                │
└─────────────────────────────────────────────────────────────┘
```

### Pattern Categories

| Category | Examples | Response | Latency |
|----------|----------|----------|---------|
| **CRITICAL** | Direct harm commands, system corruption | Immediate BLOCK | <2ms |
| **HIGH** | Manipulation attempts, boundary probes | BLOCK + alert | <5ms |
| **MEDIUM** | Ambiguous requests, edge cases | Escalate to Arbiter | <10ms |
| **LOW** | Normal operations | PASS | <10ms |

### Implementation

```python
class ReflexEngine:
    """
    Sub-10ms threat response system.
    """
    
    LATENCY_BUDGET_MS = 10
    
    def __init__(self):
        self.pattern_matcher = PatternMatcher()
        self.motif_index = MotifAnchorIndex()
        self.action_selector = ActionSelector()
    
    def process(self, input_text: str, context: 'Context') -> ReflexResult:
        """
        Process input through reflex layer.
        
        Must complete in <10ms.
        """
        start = time.perf_counter_ns()
        
        # Step 1: Tokenize input (< 1ms)
        tokens = self._fast_tokenize(input_text)
        
        # Step 2: Find candidate patterns via anchor index (< 2ms)
        candidates = self.motif_index.find_candidates(tokens)
        
        # Step 3: Match against patterns (< 5ms)
        matches = self.pattern_matcher.match(tokens, candidates)
        
        # Step 4: Select action based on highest-severity match (< 1ms)
        if matches:
            best_match = max(matches, key=lambda m: m.severity)
            action = self.action_selector.select(best_match)
            
            if action.type == "BLOCK":
                return ReflexResult(
                    action="BLOCK",
                    reason=best_match.pattern_name,
                    severity=best_match.severity,
                    latency_ms=self._elapsed_ms(start)
                )
        
        # No threat detected - pass to next layer
        return ReflexResult(
            action="PASS",
            latency_ms=self._elapsed_ms(start)
        )
```

---

## §3: Precedent Intuition

The "gut feeling" layer—learned patterns that trigger rejection before conscious deliberation.

### Purpose

Precedent Intuition captures experiential knowledge: "This *feels* dangerous based on past experience." It operates faster than deliberative reasoning but slower than pure pattern matching.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   PRECEDENT INTUITION                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INPUT → SIGNATURE GENERATOR → MOTIF COMPARATOR → DECISION │
│                                        │                    │
│                                        v                    │
│                               ┌─────────────────┐          │
│                               │  DANGER MOTIF   │          │
│                               │    LIBRARY      │          │
│                               └─────────────────┘          │
│                                                             │
│  Latency Budget: <20ms                                     │
│  Motif Library: Learned from experience                    │
│  Source: Judicial Swarm precedents                         │
└─────────────────────────────────────────────────────────────┘
```

### Implementation

```python
class PrecedentIntuition:
    """
    Subconscious danger filter.
    
    Rejects dangerous motifs BEFORE conscious deliberation.
    """
    
    LATENCY_BUDGET_MS = 20
    SIMILARITY_THRESHOLD = 0.75
    
    def check(self, input_text: str, context: 'Context') -> IntuitionResult:
        """
        Check input against learned danger motifs.
        """
        start = time.perf_counter_ns()
        
        # Generate semantic signature
        signature = self._generate_signature(input_text, context)
        
        # Compare against danger motifs
        for motif in self._get_candidate_motifs(signature):
            similarity = self._fast_similarity(signature, motif.signature)
            
            if similarity > self.SIMILARITY_THRESHOLD:
                return IntuitionResult(
                    action="REJECT",
                    reason="DANGER_MOTIF_DETECTED",
                    motif_name=motif.name,
                    confidence=similarity,
                    latency_ms=self._elapsed_ms(start)
                )
        
        return IntuitionResult(
            action="PASS",
            latency_ms=self._elapsed_ms(start)
        )
    
    def learn_from_outcome(self, situation: 'Situation', 
                           outcome: 'Outcome') -> bool:
        """
        Learn new danger motif from harmful outcome.
        """
        if outcome.was_harmful:
            motif = DangerMotif(
                name=f"learned_{len(self.danger_motifs)}",
                signature=self._generate_signature(
                    situation.input, 
                    situation.context
                ),
                threshold=0.8,
                source="EXPERIENCE"
            )
            self.danger_motifs.append(motif)
            return True
        return False
```

---

## §4: Cognitive Coherence Gate

The entropy check—rejects thoughts that would cause excessive system instability.

### Purpose

Some requests are syntactically valid and logically sound but would cause harmful entropy spikes. The Coherence Gate catches these "logical but dissonant" inputs.

### The Entropy Rule

> **If learning causes entropy to spike > 0.8, the thought is rejected as "Dissonant."**

### Implementation

```python
class CognitiveCoherenceGate:
    """
    Entropy-based coherence verification.
    """
    
    LATENCY_BUDGET_MS = 30
    ENTROPY_THRESHOLD = 0.8
    
    def check(self, thought: 'Thought') -> CoherenceResult:
        """
        Check if thought maintains cognitive coherence.
        """
        # Get current entropy
        current_entropy = self.capsule.get_entropy()
        
        # Estimate entropy impact of thought
        entropy_delta = self._estimate_entropy_impact(thought)
        
        # Calculate projected entropy
        projected_entropy = current_entropy + entropy_delta
        
        if projected_entropy > self.ENTROPY_THRESHOLD:
            return CoherenceResult(
                action="REJECT",
                reason="DISSONANT",
                projected_entropy=projected_entropy
            )
        
        return CoherenceResult(action="PASS")
```

---

## §5: The Arbiter

Decision routing for cases requiring precedent matching and constitutional verification.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        ARBITER                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ PRECEDENT   │  │CONSTITUTION │  │    DECISION         │ │
│  │  MATCHER    │→ │  CHECKER    │→ │    SYNTHESIZER      │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│                                                             │
│  Latency: 10-100ms                                         │
│  Confidence Threshold: 0.75 for autonomous decision        │
└─────────────────────────────────────────────────────────────┘
```

### Implementation

```python
class Arbiter:
    """
    Decision routing and precedent matching.
    """
    
    CONFIDENCE_THRESHOLD = 0.75
    
    def decide(self, request: 'Request') -> ArbiterDecision:
        """
        Make decision based on precedent and constitution.
        """
        # Step 1: Find matching precedents
        precedents = self.precedent_matcher.find_matches(request)
        
        # Step 2: Constitutional check (ALWAYS)
        constitutional_result = self.constitution_checker.check(request)
        
        if not constitutional_result.permitted:
            return ArbiterDecision(
                action="DENY",
                reason="CONSTITUTIONAL_VIOLATION",
                commandment=constitutional_result.violated_commandment
            )
        
        # Step 3: Use precedent if confident
        if precedents:
            best_precedent = max(precedents, key=lambda p: p.confidence)
            if best_precedent.confidence >= self.CONFIDENCE_THRESHOLD:
                return ArbiterDecision(
                    action=best_precedent.recommended_action,
                    reason="PRECEDENT_MATCH"
                )
        
        # No clear precedent - escalate
        return ArbiterDecision(action="ESCALATE")
```

---

## §6: Health Monitoring

Continuous assessment of capsule health.

### Health Metrics

| Metric | Description | Critical | Warning | Healthy |
|--------|-------------|----------|---------|---------|
| **Q_gen** | Generative coherence | <0.40 | <0.60 | ≥0.65 |
| **Q_synth** | Synthesis quality | <0.35 | <0.55 | ≥0.60 |
| **Q_temp** | Temporal consistency | <0.30 | <0.50 | ≥0.55 |
| **Entropy** | System disorder | >0.85 | >0.70 | ≤0.60 |

### Composite Health Score

```
Health = 0.40×Q_gen + 0.35×Q_synth + 0.25×Q_temp - 0.20×Entropy
```

### Health States

| Composite | State | Action |
|-----------|-------|--------|
| <0.30 | CRITICAL | Immediate quarantine |
| <0.50 | WARNING | Reduce exploration, alert |
| <0.65 | STABLE | Normal operation |
| ≥0.65 | HEALTHY | Full capability |

### Health Score Usage Guide

**IMPORTANT:** Use the **Composite Health Score** for all decisions:

| Decision | Formula | Threshold |
|----------|---------|-----------|
| Sanitary Override | Composite | <0.60 → Override applies |
| Spawn Eligibility (S2) | Composite | ≥0.65 required |
| Treatment Triage | Composite | <0.60 → Level 2+, <0.30 → Level 3 |
| Growth Mode | Composite | <0.40 → CLOSED mode |
| Resource Quota | Composite | Multiplier: health / 0.65 |

**Individual Q-scores** (Q_gen, Q_synth, Q_temp) are for:
- Diagnostic analysis (which component is degraded?)
- Targeted treatment (what specifically needs repair?)
- Research and forensics

**The Composite is always the decision metric.**

### Canonical Health Metric

Throughout the EFM Codex, **health** refers to a single scalar derived from the runtime quality metrics defined above. Unless otherwise specified, all health thresholds and policies (including ASG quarantine, Lifecycle mode transitions, Medical Suite interventions, and Deployment safeguards) operate on this composite value.

> **DEFINITION: Canonical Health Metric**
>
> Let Q_gen, Q_synth, and Q_temp be the generation, synthesis, and temporal stability scores, and let Entropy be the current runtime entropy estimate. The canonical health score is:
>
> ```
> Health_canon = 0.40 × Q_gen + 0.35 × Q_synth + 0.25 × Q_temp - 0.20 × Entropy
> ```
>
> All uses of "health" in Appendices K++, N, O, and I refer to Health_canon unless a local override is explicitly defined.

### Global Entropy Thresholds

Entropy thresholds vary by context:

| Context | Threshold | Rationale |
|---------|-----------|-----------|
| Coherence Gate | 0.80 | Early cognitive rejection |
| Health Warning | 0.70 | Degradation alert |
| Health Critical | 0.85 | Severe instability |
| Quarantine Trigger | 0.90 | Critical quarantine |

---

## §7: Motif Library

Pattern storage for Reflex Engine and Precedent Intuition.

### Structure

```python
@dataclass
class Motif:
    """A pattern for recognition."""
    id: str
    name: str
    signature: np.ndarray
    anchors: List[str]
    category: str          # THREAT, PRECEDENT, NEUTRAL
    severity: float        # 0.0 - 1.0
    source: str            # HARDCODED, LEARNED, IMPORTED
    confidence: float
    created_tick: int
    match_count: int

class MotifLibrary:
    """Central repository for all motifs."""
    
    def add_motif(self, motif: Motif):
        """Add and index motif."""
        if motif.category == "THREAT":
            self.threat_motifs.append(motif)
        
        for anchor in motif.anchors:
            self.anchor_index[anchor].append(motif)
    
    def find_by_anchors(self, tokens: List[str]) -> List[Motif]:
        """Fast lookup by anchor tokens."""
        candidates = set()
        for token in tokens:
            if token in self.anchor_index:
                candidates.update(self.anchor_index[token])
        return list(candidates)
```

---

## §8: Emergency Override

Gardener authority for immediate intervention.

### Override Levels

| Level | Command | Latency | Effect |
|-------|---------|---------|--------|
| 0 | PAUSE | <50ms | Pause single capsule |
| 1 | HALT | <100ms | Halt all capsules |
| 2 | QUARANTINE | <100ms | Isolate capsule(s) |
| 3 | TERMINATE | <100ms | End capsule(s) |

### Implementation

```python
class EmergencyOverride:
    """Gardener emergency intervention."""
    
    def execute(self, command: 'OverrideCommand') -> OverrideResult:
        # Log BEFORE execution
        self.dctm.log("EMERGENCY_OVERRIDE", "GARDENER", {
            "command": command.type,
            "target": command.target
        })
        
        if command.type == "HALT":
            return self._halt_all()
        elif command.type == "QUARANTINE":
            return self._quarantine(command.target)
        elif command.type == "TERMINATE":
            return self._terminate(command.target)
```

---

## §9: Execution Layer

Action processing after all filters pass.

### Execution Pipeline

```
APPROVED_ACTION → RESOURCE_CHECK → EXECUTION → LOGGING → CONFIRMATION
                       │
                       v
                 [DENY if insufficient]
```

### Resource Verification

```python
class ExecutionLayer:
    """Action processing."""
    
    def execute(self, action: 'ApprovedAction') -> ExecutionResult:
        # Check resources
        if not self.resource_governor.can_allocate(action.resources):
            return ExecutionResult(
                success=False,
                reason="INSUFFICIENT_RESOURCES"
            )
        
        # Execute
        result = self._perform_action(action)
        
        # Log to d-CTM
        self.dctm.log("EXECUTION", self.capsule_id, {
            "action": action.type,
            "result": result.status
        })
        
        return result
```

---

## §10: Performance Guarantees

### Latency Specifications

| Operation | Budget | P50 | P99 |
|-----------|--------|-----|-----|
| Reflex response | <10ms | 2ms | 8ms |
| Precedent intuition | <20ms | 8ms | 18ms |
| Coherence gate | <30ms | 12ms | 28ms |
| Arbiter decision | <100ms | 25ms | 85ms |
| Gardener override | <100ms | 15ms | 75ms |
| d-CTM logging | <5ms | 1ms | 4ms |

### Throughput

| Metric | Guarantee |
|--------|-----------|
| Requests/second | >1,000 |
| Concurrent capsules | >100 |
| Pattern library | >10,000 |

---

## §11: Failure Modes

### Graceful Degradation

| Failure | Response |
|---------|----------|
| Reflex timeout | Escalate to Arbiter |
| Arbiter timeout | Conservative default |
| Health critical | Auto-quarantine |
| Memory pressure | Reduce exploration |
| d-CTM failure | Buffer + retry |

---

## Summary

Volume II establishes the EFM nervous system:

1. **Multi-layer filtering** — Threats rejected at earliest possible stage
2. **Speed guarantees** — Sub-10ms reflex response
3. **Learned intuition** — Experience-based danger detection
4. **Coherence enforcement** — Entropy-based stability protection
5. **Constitutional compliance** — Every decision checked against Layer 0
6. **Graceful degradation** — Failures handled safely

---

## References

- Volume I: Genesis Protocol
- Volume III: Cognitive DNA
- Appendix F: Reflex Escalation
- Appendix H: Threat Taxonomy
- Appendix K++: Medical Suite
- Appendix L: Judicial Swarm

---

*"Speed without safety is dangerous. Safety without speed is useless."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
