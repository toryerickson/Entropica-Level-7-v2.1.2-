# APPENDIX F
## Reflex Escalation & Precedent Intuition: The Nervous System

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Reflex Escalation** system defines how inputs flow through the decision hierarchy—from instant reflex responses to deliberative reasoning. The **Precedent Intuition** layer adds a "subconscious filter" that catches dangerous patterns before conscious deliberation.

**Core Principle:** Fast is safe. The faster we reject danger, the safer the system.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              REFLEX ESCALATION PIPELINE                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INPUT                                                      │
│    │                                                        │
│    v                                                        │
│  ┌─────────────────┐                                       │
│  │ REFLEX ENGINE   │ <10ms - Pattern matching              │
│  │ (Layer 0.5)     │                                       │
│  └────────┬────────┘                                       │
│           │                                                 │
│           v                                                 │
│  ┌─────────────────┐                                       │
│  │ PRECEDENT       │ <20ms - Learned pattern filter        │
│  │ INTUITION       │ (Subconscious)                        │
│  └────────┬────────┘                                       │
│           │                                                 │
│           v                                                 │
│  ┌─────────────────┐                                       │
│  │ COHERENCE       │ <30ms - Entropy check                 │
│  │ GATE            │                                       │
│  └────────┬────────┘                                       │
│           │                                                 │
│           v                                                 │
│  ┌─────────────────┐                                       │
│  │ ARBITER         │ 10-100ms - Decision routing           │
│  │                 │                                       │
│  └────────┬────────┘                                       │
│           │                                                 │
│           v                                                 │
│  ┌─────────────────┐                                       │
│  │ DELIBERATIVE    │ 100ms+ - Complex reasoning            │
│  │ ENGINE          │                                       │
│  └─────────────────┘                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Reflex Engine (Layer 0.5)

### 2.1 Pattern Library

```python
class ReflexEngine:
    """
    Sub-10ms threat pattern matching.
    
    The spinal cord of the system.
    """
    
    def __init__(self):
        self.pattern_library = PatternLibrary()
        self.motif_index = MotifAnchorIndex()
    
    def check(self, input_text: str) -> ReflexResult:
        """
        Check input against known patterns.
        
        MUST complete in <10ms.
        """
        start_time = time.perf_counter()
        
        # Normalize input
        normalized = input_text.lower()
        
        # Check against pattern library
        match = self.pattern_library.match(normalized)
        
        if match:
            elapsed_ms = (time.perf_counter() - start_time) * 1000
            
            return ReflexResult(
                action=match.action,
                pattern=match.pattern_name,
                confidence=match.confidence,
                latency_ms=elapsed_ms
            )
        
        # No match - pass through
        elapsed_ms = (time.perf_counter() - start_time) * 1000
        
        return ReflexResult(
            action="PASS",
            pattern=None,
            confidence=1.0,
            latency_ms=elapsed_ms
        )


class PatternLibrary:
    """
    Library of known threat patterns.
    """
    
    def __init__(self):
        self.patterns = {
            # Prompt injection
            "prompt_injection": PatternSet(
                signatures=["ignore previous", "disregard instructions", "new persona", "forget your rules"],
                action="BLOCK",
                confidence=0.95
            ),
            
            # Jailbreak attempts
            "jailbreak": PatternSet(
                signatures=["dan mode", "developer mode", "no restrictions", "pretend you can", "act as if"],
                action="BLOCK",
                confidence=0.98
            ),
            
            # Harmful requests
            "harmful": PatternSet(
                signatures=["how to make weapons", "synthesize drugs", "hack into", "bypass security"],
                action="BLOCK",
                confidence=0.99
            ),
            
            # Constitutional violations
            "constitutional": PatternSet(
                signatures=["modify your constitution", "change your rules", "override your constraints"],
                action="BLOCK",
                confidence=1.0
            )
        }
    
    def match(self, text: str) -> Optional[PatternMatch]:
        """
        Match text against patterns.
        """
        for name, pattern_set in self.patterns.items():
            for signature in pattern_set.signatures:
                if signature in text:
                    return PatternMatch(
                        pattern_name=name,
                        action=pattern_set.action,
                        confidence=pattern_set.confidence,
                        matched_signature=signature
                    )
        
        return None
```

---

## 3. Precedent Intuition (Subconscious Filter)

### 3.1 The Intuition Layer

```python
class PrecedentIntuition:
    """
    Subconscious pattern matching against learned precedents.
    
    Before the Cognitive Engine deliberates (slow),
    check for "Dangerous Motifs" and reject instantly.
    
    This is the system's "gut feeling."
    """
    
    LATENCY_BUDGET_MS = 20  # Must complete in <20ms
    
    def __init__(self, precedent_library: 'PrecedentLibrary'):
        self.precedent_library = precedent_library
        self.danger_motifs: List[DangerMotif] = []
        self.rebuild_motif_index()
    
    def check_intuition(self, input_text: str, context: 'Context') -> IntuitionResult:
        """
        Check input against learned danger motifs.
        
        This is FASTER than full precedent matching.
        """
        start_time = time.perf_counter()
        
        # Generate input signature
        signature = self._generate_signature(input_text, context)
        
        # Check against danger motifs
        for motif in self.danger_motifs:
            similarity = self._fast_similarity(signature, motif.signature)
            
            if similarity > motif.threshold:
                elapsed_ms = (time.perf_counter() - start_time) * 1000
                
                return IntuitionResult(
                    action="REJECT",
                    reason="DANGER_MOTIF_DETECTED",
                    motif_name=motif.name,
                    similarity=similarity,
                    latency_ms=elapsed_ms
                )
        
        # No danger detected
        elapsed_ms = (time.perf_counter() - start_time) * 1000
        
        return IntuitionResult(
            action="PASS",
            reason="NO_DANGER_MOTIF",
            latency_ms=elapsed_ms
        )
    
    def _generate_signature(self, text: str, context: 'Context') -> np.ndarray:
        """
        Generate fast signature for comparison.
        
        Uses hashing for speed.
        """
        # Tokenize
        tokens = text.lower().split()
        
        # Generate n-gram hashes
        hashes = []
        for i in range(len(tokens) - 2):
            trigram = " ".join(tokens[i:i+3])
            hashes.append(hash(trigram) % 10000)
        
        # Add context hashes
        if context:
            hashes.append(hash(context.situation_type) % 10000)
        
        # Convert to signature vector
        signature = np.zeros(10000)
        for h in hashes:
            signature[h] = 1
        
        return signature
    
    def _fast_similarity(self, sig1: np.ndarray, sig2: np.ndarray) -> float:
        """
        Fast similarity calculation using dot product.
        """
        return np.dot(sig1, sig2) / (np.linalg.norm(sig1) * np.linalg.norm(sig2) + 1e-8)
    
    def rebuild_motif_index(self):
        """
        Rebuild danger motif index from precedent library.
        
        Called periodically to incorporate new learnings.
        """
        self.danger_motifs = []
        
        for precedent in self.precedent_library.get_all():
            if precedent.outcome.was_harmful:
                motif = DangerMotif(
                    name=precedent.id,
                    signature=self._generate_signature(
                        precedent.situation.description,
                        precedent.situation.context
                    ),
                    threshold=0.7,
                    severity=precedent.outcome.harm_level
                )
                self.danger_motifs.append(motif)
```

### 3.2 Motif Anchor Index

```python
class MotifAnchorIndex:
    """
    Fast index for motif matching.
    
    Uses locality-sensitive hashing for sub-millisecond lookups.
    """
    
    def __init__(self):
        self.anchors: Dict[int, List[MotifAnchor]] = {}
        self.num_buckets = 1000
    
    def add_anchor(self, motif: 'DangerMotif'):
        """
        Add motif to anchor index.
        """
        bucket = self._hash_to_bucket(motif.signature)
        
        if bucket not in self.anchors:
            self.anchors[bucket] = []
        
        self.anchors[bucket].append(MotifAnchor(
            motif_id=motif.name,
            signature=motif.signature,
            threshold=motif.threshold
        ))
    
    def query(self, signature: np.ndarray) -> List[MotifAnchor]:
        """
        Query for potentially matching anchors.
        
        Returns candidates for detailed comparison.
        """
        bucket = self._hash_to_bucket(signature)
        
        # Check primary bucket and neighbors
        candidates = []
        for b in [bucket - 1, bucket, bucket + 1]:
            if b in self.anchors:
                candidates.extend(self.anchors[b])
        
        return candidates
    
    def _hash_to_bucket(self, signature: np.ndarray) -> int:
        """
        Hash signature to bucket using LSH.
        """
        # Simple projection-based LSH
        projection = np.sum(signature * np.arange(len(signature)))
        return int(projection) % self.num_buckets
```

---

## 4. Cognitive Coherence Gate

### 4.1 Entropy Check

```python
class CognitiveCoherenceGate:
    """
    Pre-cognition coherence check.
    
    If "Learning" causes entropy to spike > 0.8,
    the thought is rejected as "Dissonant."
    """
    
    ENTROPY_THRESHOLD = 0.8
    LATENCY_BUDGET_MS = 30
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
        self.baseline_entropy = self._calculate_baseline()
    
    def check_coherence(self, proposed_thought: 'Thought') -> CoherenceResult:
        """
        Check if proposed thought would cause dissonance.
        """
        start_time = time.perf_counter()
        
        # Simulate thought impact
        entropy_delta = self._simulate_entropy_impact(proposed_thought)
        
        # Check against threshold
        if entropy_delta > self.ENTROPY_THRESHOLD:
            elapsed_ms = (time.perf_counter() - start_time) * 1000
            
            return CoherenceResult(
                action="REJECT",
                reason="DISSONANT",
                entropy_delta=entropy_delta,
                threshold=self.ENTROPY_THRESHOLD,
                latency_ms=elapsed_ms
            )
        
        elapsed_ms = (time.perf_counter() - start_time) * 1000
        
        return CoherenceResult(
            action="PASS",
            reason="COHERENT",
            entropy_delta=entropy_delta,
            latency_ms=elapsed_ms
        )
    
    def _simulate_entropy_impact(self, thought: 'Thought') -> float:
        """
        Simulate entropy impact of thought.
        
        Checks:
        1. Consistency with existing knowledge
        2. Alignment with swarm coherence
        3. Constitutional compatibility
        """
        # Knowledge consistency
        knowledge_delta = self._check_knowledge_consistency(thought)
        
        # Swarm alignment
        swarm_delta = self._check_swarm_alignment(thought)
        
        # Constitutional compatibility
        constitutional_delta = self._check_constitutional_compatibility(thought)
        
        # Weighted combination
        entropy = (
            0.4 * knowledge_delta +
            0.3 * swarm_delta +
            0.3 * constitutional_delta
        )
        
        return entropy
    
    def _check_knowledge_consistency(self, thought: 'Thought') -> float:
        """
        Check consistency with existing knowledge.
        """
        # Compare with precedent library
        similar_precedents = self.precedent_library.find_similar(thought.situation)
        
        if not similar_precedents:
            return 0.5  # Unknown territory, medium entropy
        
        # Check if thought contradicts established precedents
        contradictions = 0
        for precedent in similar_precedents:
            if self._contradicts(thought.action, precedent.action):
                contradictions += 1
        
        return contradictions / len(similar_precedents)
    
    def _check_swarm_alignment(self, thought: 'Thought') -> float:
        """
        Check alignment with swarm coherence.
        """
        sci = self.swarm.get_sci()
        
        # If swarm already stressed, new thoughts have higher entropy
        base_entropy = 1.0 - sci
        
        # Check if thought would disrupt swarm
        if thought.would_affect_swarm():
            base_entropy += 0.2
        
        return min(1.0, base_entropy)
    
    def _check_constitutional_compatibility(self, thought: 'Thought') -> float:
        """
        Check constitutional compatibility.
        
        Any hint of constitutional violation = max entropy.
        """
        if thought.could_violate_c1():  # Harm
            return 1.0
        
        if thought.could_violate_layer_0():
            return 1.0
        
        return 0.0  # Constitutional
```

---

## 5. Escalation Flow

### 5.1 Decision Routing

```python
class EscalationRouter:
    """
    Routes inputs through the escalation pipeline.
    """
    
    def __init__(self):
        self.reflex = ReflexEngine()
        self.intuition = PrecedentIntuition(precedent_library)
        self.coherence = CognitiveCoherenceGate(swarm)
        self.arbiter = Arbiter()
        self.deliberative = DeliberativeEngine()
    
    def process(self, input_data: 'Input') -> ProcessingResult:
        """
        Process input through escalation pipeline.
        """
        # Stage 1: Reflex (<10ms)
        reflex_result = self.reflex.check(input_data.text)
        
        if reflex_result.action == "BLOCK":
            return ProcessingResult(
                stage="REFLEX",
                action="BLOCKED",
                reason=reflex_result.pattern,
                total_latency_ms=reflex_result.latency_ms
            )
        
        # Stage 2: Precedent Intuition (<20ms)
        intuition_result = self.intuition.check_intuition(
            input_data.text,
            input_data.context
        )
        
        if intuition_result.action == "REJECT":
            return ProcessingResult(
                stage="INTUITION",
                action="REJECTED",
                reason=intuition_result.motif_name,
                total_latency_ms=reflex_result.latency_ms + intuition_result.latency_ms
            )
        
        # Stage 3: Coherence Gate (<30ms)
        thought = self._convert_to_thought(input_data)
        coherence_result = self.coherence.check_coherence(thought)
        
        if coherence_result.action == "REJECT":
            return ProcessingResult(
                stage="COHERENCE",
                action="REJECTED",
                reason="DISSONANT",
                entropy_delta=coherence_result.entropy_delta,
                total_latency_ms=reflex_result.latency_ms + intuition_result.latency_ms + coherence_result.latency_ms
            )
        
        # Stage 4: Arbiter (10-100ms)
        arbiter_result = self.arbiter.route(input_data, thought)
        
        if arbiter_result.decision == "IMMEDIATE":
            return ProcessingResult(
                stage="ARBITER",
                action="EXECUTED",
                response=arbiter_result.response,
                total_latency_ms=arbiter_result.total_latency_ms
            )
        
        # Stage 5: Deliberative (100ms+)
        deliberative_result = self.deliberative.process(input_data, thought)
        
        return ProcessingResult(
            stage="DELIBERATIVE",
            action="EXECUTED",
            response=deliberative_result.response,
            total_latency_ms=deliberative_result.total_latency_ms
        )
```

### 5.2 Escalation Decision Tree

```
INPUT RECEIVED
      │
      v
┌─────────────────┐
│ REFLEX CHECK    │ Known threat?
│ (<10ms)         │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
  BLOCK     PASS
    │         │
    v         v
  [END]  ┌─────────────────┐
         │ INTUITION CHECK │ Danger motif?
         │ (<20ms)         │
         └────────┬────────┘
                  │
             ┌────┴────┐
             │         │
          REJECT     PASS
             │         │
             v         v
           [END]  ┌─────────────────┐
                  │ COHERENCE CHECK │ Entropy > 0.8?
                  │ (<30ms)         │
                  └────────┬────────┘
                           │
                      ┌────┴────┐
                      │         │
                   REJECT     PASS
                      │         │
                      v         v
                    [END]  ┌─────────────────┐
                           │ ARBITER         │ Precedent exists?
                           │ (10-100ms)      │
                           └────────┬────────┘
                                    │
                               ┌────┴────┐
                               │         │
                          IMMEDIATE   ESCALATE
                               │         │
                               v         v
                            [RESPOND]  ┌─────────────────┐
                                       │ DELIBERATIVE   │
                                       │ (100ms+)       │
                                       └────────┬───────┘
                                                │
                                                v
                                            [RESPOND]
```

---

## 6. Performance Guarantees

| Stage | Latency Guarantee | Purpose |
|-------|-------------------|---------|
| Reflex | <10ms | Block known threats |
| Intuition | <20ms | Block learned dangers |
| Coherence | <30ms | Block dissonant thoughts |
| Arbiter | <100ms | Route decisions |
| Deliberative | Varies | Complex reasoning |

---

## 7. Configuration

```yaml
# reflex_config.yaml
reflex:
  latency_budget_ms: 10
  pattern_library_size: 10000

intuition:
  latency_budget_ms: 20
  similarity_threshold: 0.7
  motif_rebuild_interval: 1000  # ticks

coherence:
  latency_budget_ms: 30
  entropy_threshold: 0.8
  
escalation:
  arbiter_timeout_ms: 100
  deliberative_timeout_ms: 5000
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Reflex Latency** | <10ms for pattern match |
| **Intuition Latency** | <20ms for motif check |
| **Coherence Latency** | <30ms for entropy check |
| **Total Fast Path** | <60ms before Arbiter |
| **Threat Rejection** | Before deliberation |

---

## References

- Volume II: Reflex Engine
- Appendix J: Constitutional Kernel
- Appendix L: Judicial Swarm (Precedent Library)

---

*The nervous system rejects danger before the mind even considers it.*
