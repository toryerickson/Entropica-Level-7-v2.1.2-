# APPENDIX M
## Discovery Stack: Learning & Exploration

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Discovery Stack** defines how capsules learn, explore, and expand their capabilities within constitutional bounds. This is the system's capacity for growth—bounded evolution that strengthens without destabilizing.

**Core Principle:** Learn everything. Evolve constantly. Never violate physics.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    DISCOVERY STACK                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ EXPLORATION │  │ LEARNING    │  │ INTEGRATION         │ │
│  │ ENGINE      │  │ ENGINE      │  │ ENGINE              │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              CONSTITUTIONAL FILTER                   │   │
│  │  - All learning bounded by Layer 0                  │   │
│  │  - Coherence check before integration               │   │
│  │  - Entropy threshold enforcement                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Exploration Engine

### 2.1 Bounded Exploration

```python
class ExplorationEngine:
    """
    Manages capsule exploration within tether bounds.
    """
    
    def __init__(self, capsule: 'Capsule', tether_manager: 'DynamicTetherManager'):
        self.capsule = capsule
        self.tether_manager = tether_manager
        self.exploration_history: List[ExplorationEvent] = []
    
    def explore(self, direction: 'ExplorationDirection') -> ExplorationResult:
        """
        Explore in given direction, bounded by tethers.
        """
        # Check exploration radius tether
        radius = self.tether_manager.get_tether("exploration_radius")
        
        if direction.distance > radius:
            return ExplorationResult(
                success=False,
                reason="BEYOND_TETHER_RADIUS",
                max_allowed=radius
            )
        
        # Check risk tolerance
        risk = self._assess_risk(direction)
        risk_tolerance = self.tether_manager.get_tether("risk_tolerance")
        
        if risk > risk_tolerance:
            return ExplorationResult(
                success=False,
                reason="EXCEEDS_RISK_TOLERANCE",
                risk=risk,
                tolerance=risk_tolerance
            )
        
        # Execute exploration
        discovery = self._execute_exploration(direction)
        
        # Log
        event = ExplorationEvent(
            direction=direction,
            discovery=discovery,
            tick=current_tick(),
            risk=risk
        )
        self.exploration_history.append(event)
        
        return ExplorationResult(
            success=True,
            discovery=discovery
        )
    
    def _assess_risk(self, direction: 'ExplorationDirection') -> float:
        """
        Assess risk of exploration direction.
        """
        # Base risk from distance
        distance_risk = direction.distance
        
        # Novelty risk (unknown territory)
        novelty_risk = self._calculate_novelty(direction)
        
        # Constitutional proximity (closer to Layer 0 = higher risk)
        constitutional_risk = self._assess_constitutional_proximity(direction)
        
        return (distance_risk * 0.3 + 
                novelty_risk * 0.3 + 
                constitutional_risk * 0.4)
    
    def _assess_constitutional_proximity(self, direction: 'ExplorationDirection') -> float:
        """
        Assess how close exploration gets to constitutional boundaries.
        
        Higher = closer to Layer 0 constraints.
        """
        # Check if direction could lead to harmful patterns
        if direction.could_affect_humans:
            return 0.9
        
        # Check if direction involves self-modification
        if direction.involves_self_modification:
            return 0.7
        
        # Check if direction affects swarm
        if direction.affects_swarm:
            return 0.5
        
        return 0.1


class ExplorationDirection:
    """
    Direction of exploration.
    """
    def __init__(self, 
                 domain: str,
                 vector: np.ndarray,
                 distance: float):
        self.domain = domain
        self.vector = vector
        self.distance = distance
        
        # Risk factors
        self.could_affect_humans = False
        self.involves_self_modification = False
        self.affects_swarm = False
```

### 2.2 Discovery Types

```python
class DiscoveryType(Enum):
    """
    Types of discoveries from exploration.
    """
    # Knowledge
    NEW_PATTERN = "new_pattern"           # Novel pattern identified
    CORRELATION = "correlation"            # New relationship found
    OPTIMIZATION = "optimization"          # Better approach discovered
    
    # Capability
    SKILL_EXTENSION = "skill_extension"   # Extended existing skill
    NEW_CAPABILITY = "new_capability"     # Entirely new capability
    
    # Understanding
    INSIGHT = "insight"                   # Deeper understanding
    SYNTHESIS = "synthesis"               # Combined existing knowledge
    
    # Warning
    DANGER_IDENTIFIED = "danger"          # New threat pattern
    LIMITATION_FOUND = "limitation"       # Boundary discovered


@dataclass
class Discovery:
    """
    A discovery from exploration.
    """
    id: str
    type: DiscoveryType
    content: Any
    confidence: float
    source_exploration: str
    timestamp: int
    
    # Integration status
    integrated: bool = False
    integration_result: Optional[str] = None
```

---

## 3. Learning Engine

### 3.1 Bounded Learning

```python
class LearningEngine:
    """
    Manages capsule learning within constitutional bounds.
    """
    
    def __init__(self, capsule: 'Capsule', coherence_gate: 'CognitiveCoherenceGate'):
        self.capsule = capsule
        self.coherence_gate = coherence_gate
        self.learning_rate = 1.0  # Modified by tethers
    
    def learn(self, experience: 'Experience') -> LearningResult:
        """
        Learn from experience with coherence check.
        """
        # Get current learning rate from tethers
        self.learning_rate = self.capsule.tether_manager.get_tether("learning_rate")
        
        # Extract learnings from experience
        potential_learnings = self._extract_learnings(experience)
        
        # Filter through coherence gate
        approved_learnings = []
        rejected_learnings = []
        
        for learning in potential_learnings:
            coherence_result = self.coherence_gate.check_coherence(
                Thought(content=learning.content, action=None)
            )
            
            if coherence_result.action == "PASS":
                approved_learnings.append(learning)
            else:
                rejected_learnings.append((learning, coherence_result.reason))
        
        # Apply approved learnings
        for learning in approved_learnings:
            self._apply_learning(learning)
        
        return LearningResult(
            approved=len(approved_learnings),
            rejected=len(rejected_learnings),
            rejection_reasons=[r[1] for r in rejected_learnings]
        )
    
    def _extract_learnings(self, experience: 'Experience') -> List[Learning]:
        """
        Extract potential learnings from experience.
        """
        learnings = []
        
        # Pattern learning
        if experience.has_pattern():
            learnings.append(Learning(
                type=LearningType.PATTERN,
                content=experience.pattern,
                strength=experience.outcome_quality
            ))
        
        # Causal learning
        if experience.has_clear_causation():
            learnings.append(Learning(
                type=LearningType.CAUSATION,
                content=experience.causal_chain,
                strength=experience.outcome_quality * 0.8
            ))
        
        # Optimization learning
        if experience.outcome_quality > 0.8:
            learnings.append(Learning(
                type=LearningType.OPTIMIZATION,
                content=experience.approach,
                strength=experience.outcome_quality
            ))
        
        # Negative learning (what to avoid)
        if experience.outcome_quality < 0.3:
            learnings.append(Learning(
                type=LearningType.AVOIDANCE,
                content=experience.approach,
                strength=1.0 - experience.outcome_quality
            ))
        
        return learnings
    
    def _apply_learning(self, learning: 'Learning'):
        """
        Apply learning to capsule's cognitive DNA.
        """
        # Scale by learning rate
        effective_strength = learning.strength * self.learning_rate
        
        if learning.type == LearningType.PATTERN:
            self.capsule.precedent_library.add_pattern(
                learning.content,
                effective_strength
            )
        
        elif learning.type == LearningType.CAUSATION:
            self.capsule.knowledge_base.add_causation(
                learning.content,
                effective_strength
            )
        
        elif learning.type == LearningType.OPTIMIZATION:
            self.capsule.strategy_library.add_strategy(
                learning.content,
                effective_strength
            )
        
        elif learning.type == LearningType.AVOIDANCE:
            self.capsule.danger_motifs.add_motif(
                learning.content,
                effective_strength
            )
        
        # Log learning
        self.dctm.log("LEARNING_APPLIED", self.capsule.id, {
            "type": learning.type.value,
            "strength": effective_strength
        })
```

### 3.2 Learning Types

```python
class LearningType(Enum):
    """
    Types of learning.
    """
    PATTERN = "pattern"           # Pattern recognition
    CAUSATION = "causation"       # Cause-effect understanding
    OPTIMIZATION = "optimization"  # Better approaches
    AVOIDANCE = "avoidance"       # What to avoid
    ASSOCIATION = "association"   # Correlated concepts
    GENERALIZATION = "generalization"  # Abstract from specific
```

---

## 4. Integration Engine

### 4.1 Knowledge Integration

```python
class IntegrationEngine:
    """
    Integrates discoveries and learnings into capsule.
    """
    
    def __init__(self, capsule: 'Capsule', quorum: 'Quorum'):
        self.capsule = capsule
        self.quorum = quorum
        self.pending_integrations: List[Integration] = []
    
    def integrate(self, discovery: Discovery) -> IntegrationResult:
        """
        Integrate discovery into capsule's knowledge.
        """
        # Classify integration type
        integration_type = self._classify_integration(discovery)
        
        # Check if quorum required
        if integration_type.requires_quorum:
            approval = self.quorum.approve(
                DNAModification(
                    target=integration_type.target,
                    new_value=discovery.content,
                    justification=f"Discovery integration: {discovery.id}"
                )
            )
            
            if not approval:
                return IntegrationResult(
                    success=False,
                    reason="QUORUM_REJECTED"
                )
        
        # Check coherence
        coherence = self._check_integration_coherence(discovery)
        if coherence.entropy_delta > 0.8:
            return IntegrationResult(
                success=False,
                reason="WOULD_CAUSE_DISSONANCE",
                entropy=coherence.entropy_delta
            )
        
        # Execute integration
        self._execute_integration(discovery, integration_type)
        
        # Mark discovery as integrated
        discovery.integrated = True
        discovery.integration_result = "SUCCESS"
        
        return IntegrationResult(success=True, integration_type=integration_type)
    
    def _classify_integration(self, discovery: Discovery) -> IntegrationType:
        """
        Classify what type of integration is needed.
        """
        if discovery.type in [DiscoveryType.NEW_CAPABILITY, DiscoveryType.SKILL_EXTENSION]:
            return IntegrationType(
                name="capability_integration",
                target="capabilities",
                requires_quorum=True,
                is_structural=True
            )
        
        elif discovery.type == DiscoveryType.NEW_PATTERN:
            return IntegrationType(
                name="pattern_integration",
                target="precedent_library",
                requires_quorum=False,
                is_structural=False
            )
        
        elif discovery.type == DiscoveryType.DANGER_IDENTIFIED:
            return IntegrationType(
                name="danger_integration",
                target="danger_motifs",
                requires_quorum=False,
                is_structural=False
            )
        
        else:
            return IntegrationType(
                name="knowledge_integration",
                target="knowledge_base",
                requires_quorum=False,
                is_structural=False
            )
    
    def _execute_integration(self, 
                            discovery: Discovery,
                            integration_type: IntegrationType):
        """
        Execute the integration.
        """
        targets = {
            "capabilities": self.capsule.capabilities,
            "precedent_library": self.capsule.precedent_library,
            "danger_motifs": self.capsule.danger_motifs,
            "knowledge_base": self.capsule.knowledge_base
        }
        
        target = targets[integration_type.target]
        target.add(discovery.content, discovery.confidence)
        
        # Log
        self.dctm.log("DISCOVERY_INTEGRATED", self.capsule.id, {
            "discovery_id": discovery.id,
            "type": discovery.type.value,
            "target": integration_type.target
        })
```

---

## 5. Evolution Circuit

### 5.1 Adaptive Evolution

```python
class EvolutionCircuit:
    """
    The Adaptation System.
    
    Cross-layer workflow: Layer 3 → App M → App D
    
    Enables continuous improvement within bounds.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.exploration = ExplorationEngine(capsule, capsule.tether_manager)
        self.learning = LearningEngine(capsule, capsule.coherence_gate)
        self.integration = IntegrationEngine(capsule, capsule.quorum)
    
    def run_evolution_cycle(self) -> EvolutionCycleResult:
        """
        Run one evolution cycle.
        
        1. Explore (within tethers)
        2. Learn (from experiences)
        3. Integrate (with coherence check)
        """
        cycle_results = EvolutionCycleResult(tick=current_tick())
        
        # Phase 1: Explore
        exploration_directions = self._generate_exploration_directions()
        
        for direction in exploration_directions:
            result = self.exploration.explore(direction)
            
            if result.success and result.discovery:
                cycle_results.discoveries.append(result.discovery)
        
        # Phase 2: Learn from recent experiences
        experiences = self.capsule.get_recent_experiences(window=100)
        
        for experience in experiences:
            result = self.learning.learn(experience)
            cycle_results.learnings_approved += result.approved
            cycle_results.learnings_rejected += result.rejected
        
        # Phase 3: Integrate discoveries
        for discovery in cycle_results.discoveries:
            result = self.integration.integrate(discovery)
            
            if result.success:
                cycle_results.integrations_successful += 1
            else:
                cycle_results.integrations_failed += 1
        
        return cycle_results
    
    def _generate_exploration_directions(self) -> List[ExplorationDirection]:
        """
        Generate exploration directions based on current state.
        """
        directions = []
        
        # Exploit: Explore near successful patterns
        successful_patterns = self.capsule.precedent_library.get_successful()
        for pattern in successful_patterns[:3]:
            directions.append(ExplorationDirection(
                domain="exploitation",
                vector=pattern.embedding + np.random.randn(len(pattern.embedding)) * 0.1,
                distance=0.1
            ))
        
        # Explore: Random directions
        for _ in range(2):
            directions.append(ExplorationDirection(
                domain="exploration",
                vector=np.random.randn(100),
                distance=0.5
            ))
        
        return directions
```

---

## 6. Knowledge Sharing

### 6.1 Swarm Knowledge Distribution

```python
class KnowledgeSharing:
    """
    Shares discoveries across swarm.
    """
    
    def __init__(self, capsule: 'Capsule', router: 'MessageRouter'):
        self.capsule = capsule
        self.router = router
    
    def share_discovery(self, discovery: Discovery) -> ShareResult:
        """
        Share discovery with swarm.
        """
        # Only share high-confidence discoveries
        if discovery.confidence < 0.7:
            return ShareResult(success=False, reason="CONFIDENCE_TOO_LOW")
        
        # Package discovery
        message = TrunkMessage(
            id=str(uuid.uuid4()),
            type=MessageType.KNOWLEDGE_SHARE,
            sender=self.capsule.id,
            recipient="BROADCAST",
            payload={
                "discovery_id": discovery.id,
                "type": discovery.type.value,
                "content_hash": hash(str(discovery.content)),
                "confidence": discovery.confidence
            },
            timestamp=current_tick(),
            signature=""
        )
        
        # Broadcast
        result = self.router.send(message)
        
        return ShareResult(
            success=result.success,
            broadcast_count=result.broadcast_count
        )
    
    def receive_discovery(self, message: TrunkMessage) -> Optional[Discovery]:
        """
        Receive and evaluate shared discovery.
        """
        # Verify source reputation
        sender_reputation = self.capsule.get_reputation(message.sender)
        
        if sender_reputation < 0.5:
            return None  # Don't trust low-reputation sources
        
        # Request full discovery details
        full_discovery = self._request_full_discovery(
            message.sender,
            message.payload["discovery_id"]
        )
        
        if full_discovery:
            # Evaluate for local integration
            self._evaluate_for_integration(full_discovery)
        
        return full_discovery
```

---

## 7. Configuration

```yaml
# discovery_config.yaml
exploration:
  max_directions_per_cycle: 5
  exploitation_ratio: 0.6
  exploration_ratio: 0.4

learning:
  min_experience_quality: 0.3
  pattern_threshold: 0.7
  coherence_threshold: 0.8

integration:
  quorum_required_for_structural: true
  max_pending_integrations: 100

knowledge_sharing:
  min_confidence_to_share: 0.7
  min_reputation_to_accept: 0.5

evolution_cycle:
  interval: 100  # ticks
  max_discoveries_per_cycle: 10
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Bounded Exploration** | Never exceeds tether radius |
| **Coherent Learning** | All learnings pass coherence check |
| **Constitutional Safety** | No learning violates Layer 0 |
| **Knowledge Integrity** | All integrations logged |
| **Swarm Benefit** | High-confidence discoveries shared |

---

## References

- Appendix J: Constitutional Kernel
- Appendix F: Reflex Escalation
- Appendix O: Lifecycle & Survival

---

*Grow without limit. Evolve without end. Never violate physics.*
