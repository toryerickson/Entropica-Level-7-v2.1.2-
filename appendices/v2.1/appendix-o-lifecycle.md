# APPENDIX O
## Lifecycle & Survival Strategies: The Metabolism

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Lifecycle & Survival Strategies** system defines how capsules adapt to environmental conditions, manage resources, and persist through adverse conditions. This is the system's "metabolism"—the dynamic regulation of growth, conservation, and survival.

**Core Principle:** The Will to Live is absolute—unless it violates Layer 0.

---

## 1. Stress Calculation System

### 1.1 Stress Definition

**Stress** is a normalized composite score (0.0 to 1.0) measuring environmental and internal pressure on a capsule. Higher stress triggers conservative behaviors.

### 1.2 Stress Formula

```python
def calculate_stress(capsule: 'Capsule', swarm: 'Swarm', rag: 'RAG') -> float:
    """
    Calculate composite stress level.
    
    Stress = Σ(weight_i × factor_i) where factors are normalized to [0, 1]
    
    Returns: float in range [0.0, 1.0]
    """
    # Factor 1: Resource Pressure (weight: 0.25)
    resource_usage = rag.get_usage_ratio(capsule.id)
    resource_pressure = max(0, (resource_usage - 0.5) * 2)  # Scales 0.5-1.0 → 0-1
    
    # Factor 2: Health Deficit (weight: 0.25)
    health = capsule.get_health().composite
    health_deficit = max(0, 1.0 - (health / 0.65))  # Below 0.65 creates stress
    
    # Factor 3: Swarm Incoherence (weight: 0.20)
    sci = swarm.get_sci()
    incoherence = max(0, 1.0 - (sci / 0.70))  # Below 0.70 creates stress
    
    # Factor 4: Threat Proximity (weight: 0.20)
    recent_blocks = capsule.reflex_engine.get_recent_block_count(window_ticks=100)
    threat_proximity = min(1.0, recent_blocks / 10)  # 10+ blocks = max stress
    
    # Factor 5: Queue Depth (weight: 0.10)
    queue_depth = rag.get_queue_depth()
    queue_pressure = min(1.0, queue_depth / 500)  # 500+ items = max stress
    
    # Weighted sum
    stress = (
        0.25 * resource_pressure +
        0.25 * health_deficit +
        0.20 * incoherence +
        0.20 * threat_proximity +
        0.10 * queue_pressure
    )
    
    return min(1.0, max(0.0, stress))  # Clamp to [0, 1]
```

### 1.3 Stress Levels

| Level | Range | Description | Tether Effect |
|-------|-------|-------------|---------------|
| **LOW** | 0.0 - 0.25 | Normal operation | Full slack (1.0×) |
| **MEDIUM** | 0.25 - 0.50 | Elevated pressure | Moderate tension (0.7×) |
| **HIGH** | 0.50 - 0.75 | Significant threat | Tight (0.4×) |
| **CRITICAL** | 0.75 - 1.0 | Survival mode | Maximum tension (0.2×) |

```python
class StressLevel(Enum):
    """Discrete stress levels for tether adjustment."""
    LOW = "low"           # 0.00 - 0.25
    MEDIUM = "medium"     # 0.25 - 0.50
    HIGH = "high"         # 0.50 - 0.75
    CRITICAL = "critical" # 0.75 - 1.00

def get_stress_level(stress: float) -> StressLevel:
    """Convert continuous stress to discrete level."""
    if stress < 0.25:
        return StressLevel.LOW
    elif stress < 0.50:
        return StressLevel.MEDIUM
    elif stress < 0.75:
        return StressLevel.HIGH
    else:
        return StressLevel.CRITICAL
```

### 1.4 Stress Response Timing

| Metric | Target | Maximum |
|--------|--------|---------|
| Stress calculation | <5ms | 10ms |
| Level determination | <1ms | 2ms |
| Tether adjustment | <10 ticks | 15 ticks |
| **Total response** | **<10 ticks** | **15 ticks** |

> **Adrenaline Test Requirement:** Tethers must tighten within 10 ticks of stress injection.

### 1.5 Stress Input Contract

Many subsystems (Lifecycle, Adaptive Spawn Governor, Resource Allocation, Dynamic Tethers) consume a single **stress** scalar in [0, 1]. This subsection defines the canonical aggregation of stress from lower-level signals.

> **DEFINITION: Canonical Stress Metric**
>
> Let Health_canon be the composite health score from Volume II, and let:
> - **E** = current entropy estimate (0–1)
> - **R** = normalized resource pressure (0–1), where 0 is abundant resources and 1 is resource exhaustion
> - **I** = normalized incident pressure (0–1), derived from the recent rate and severity of REFLEX_BLOCK, ARBITER_DENY, and QUARANTINE events in d-CTM
> - **C** = Swarm Coherence Index (SCI) from Appendix L
>
> The canonical stress value is:
>
> ```
> Stress_canon = 0.35 × (1 - Health_canon) + 0.25 × E + 0.20 × R + 0.20 × (1 - C)
> ```
>
> This produces low stress when health and coherence are high, entropy is low, and resources are plentiful; stress rises as health and SCI fall, entropy increases, and resource pressure grows.

Unless otherwise specified, all references to "stress" in Appendices N, Q, and R use Stress_canon.

---

## 2. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              LIFECYCLE & SURVIVAL SYSTEM                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ STRESS      │  │ GROWTH      │  │ PERSISTENCE         │ │
│  │ CALCULATOR  │→ │ MODE        │→ │ PROTOCOL            │ │
│  │             │  │ CONTROLLER  │  │ ENGINE              │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              DYNAMIC TETHER MANAGER                  │   │
│  │  - Stress-responsive constraints                     │   │
│  │  - Adaptive behavior modulation                      │   │
│  │  - Survival prioritization                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Growth Modes

### 2.1 The Three Modes

```python
class GrowthMode(Enum):
    """
    Operating modes that define resource consumption and exploration.
    """
    OPEN = "open"           # Maximum exploration, high resource use
    CLOSED = "closed"       # Minimal exploration, conservation mode
    SENSOR = "sensor"       # Balanced, adaptive exploration


class GrowthModeController:
    """
    Controls capsule growth mode based on environmental conditions.
    """
    
    def __init__(self, capsule: 'Capsule', rag: 'ResourceAllocationGovernor'):
        self.capsule = capsule
        self.rag = rag
        self.current_mode = GrowthMode.SENSOR  # Default
        self.mode_history: List[ModeTransition] = []
    
    def evaluate_and_set_mode(self) -> GrowthMode:
        """
        Evaluate conditions and set appropriate growth mode.
        """
        stress = self.rag.get_stress_level()
        health = self.capsule.get_health().composite
        sci = self.swarm.get_sci()
        resources = self.rag.get_available_resources()
        
        # Decision matrix
        if stress == StressLevel.CRITICAL or health < 0.4:
            new_mode = GrowthMode.CLOSED
        elif stress == StressLevel.LOW and health > 0.8 and resources.abundant:
            new_mode = GrowthMode.OPEN
        else:
            new_mode = GrowthMode.SENSOR
        
        # Record transition
        if new_mode != self.current_mode:
            self._transition_mode(new_mode)
        
        return self.current_mode
    
    def _transition_mode(self, new_mode: GrowthMode):
        """
        Execute mode transition with logging.
        """
        transition = ModeTransition(
            from_mode=self.current_mode,
            to_mode=new_mode,
            tick=current_tick(),
            reason=self._get_transition_reason(new_mode)
        )
        
        self.mode_history.append(transition)
        self.current_mode = new_mode
        
        # Log to d-CTM
        self.dctm.log("GROWTH_MODE_TRANSITION", self.capsule.id, {
            "from": transition.from_mode.value,
            "to": transition.to_mode.value,
            "reason": transition.reason
        })
        
        # Apply mode effects
        self._apply_mode_effects(new_mode)
    
    def _apply_mode_effects(self, mode: GrowthMode):
        """
        Apply mode-specific effects.
        """
        effects = {
            GrowthMode.OPEN: {
                "exploration_radius": 1.0,
                "resource_consumption": 1.0,
                "spawn_enabled": True,
                "learning_rate": 1.0
            },
            GrowthMode.SENSOR: {
                "exploration_radius": 0.5,
                "resource_consumption": 0.6,
                "spawn_enabled": True,
                "learning_rate": 0.7
            },
            GrowthMode.CLOSED: {
                "exploration_radius": 0.1,
                "resource_consumption": 0.3,
                "spawn_enabled": False,
                "learning_rate": 0.2
            }
        }
        
        self.capsule.apply_mode_effects(effects[mode])
```

### 2.2 Mode Characteristics

| Mode | Exploration | Resources | Spawning | Learning | Use Case |
|------|-------------|-----------|----------|----------|----------|
| **OPEN** | Maximum | High | Enabled | Full | Low stress, abundant resources |
| **SENSOR** | Balanced | Moderate | Enabled | Moderate | Normal operation |
| **CLOSED** | Minimal | Conservation | Disabled | Minimal | High stress, survival mode |

---

## 4. Dynamic Tethers (Mutation Tethers)

### 3.1 The Tether System

```python
class DynamicTether:
    """
    A constraint that adapts to system stress.
    
    High Stress → Tether tightens → Conservative behavior
    Low Stress → Tether loosens → Exploration enabled
    
    Tethers are the "muscles" that contract under stress.
    """
    
    def __init__(self, name: str, base_value: float, min_value: float, max_value: float):
        self.name = name
        self.base_value = base_value
        self.min_value = min_value
        self.max_value = max_value
        self.current_value = base_value
    
    def adjust_for_stress(self, stress_level: StressLevel) -> float:
        """
        Adjust tether based on stress level.
        
        Tethers TIGHTEN (decrease) under stress.
        """
        tension_multipliers = {
            StressLevel.LOW: 1.0,      # Full slack
            StressLevel.MEDIUM: 0.7,   # Some tension
            StressLevel.HIGH: 0.4,     # Tight
            StressLevel.CRITICAL: 0.2  # Maximum tension
        }
        
        multiplier = tension_multipliers[stress_level]
        range_size = self.max_value - self.min_value
        
        self.current_value = self.min_value + (range_size * multiplier)
        
        return self.current_value


class DynamicTetherManager:
    """
    Manages all dynamic tethers for a capsule.
    
    Tethers control:
    - Exploration radius
    - Resource consumption rate
    - Communication frequency
    - Learning aggressiveness
    - Risk tolerance
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        
        # Define tethers
        self.tethers = {
            "exploration_radius": DynamicTether(
                name="exploration_radius",
                base_value=1.0,
                min_value=0.1,
                max_value=1.0
            ),
            "resource_rate": DynamicTether(
                name="resource_rate",
                base_value=1.0,
                min_value=0.2,
                max_value=1.5
            ),
            "communication_frequency": DynamicTether(
                name="communication_frequency",
                base_value=1.0,
                min_value=0.3,
                max_value=1.0
            ),
            "learning_rate": DynamicTether(
                name="learning_rate",
                base_value=1.0,
                min_value=0.1,
                max_value=1.2
            ),
            "risk_tolerance": DynamicTether(
                name="risk_tolerance",
                base_value=0.5,
                min_value=0.1,
                max_value=0.8
            )
        }
    
    def update_all_tethers(self, stress_level: StressLevel) -> Dict[str, float]:
        """
        Update all tethers based on current stress.
        """
        updates = {}
        
        for name, tether in self.tethers.items():
            new_value = tether.adjust_for_stress(stress_level)
            updates[name] = new_value
        
        # Log to d-CTM
        self.dctm.log("TETHERS_UPDATED", self.capsule.id, {
            "stress_level": stress_level.value,
            "tether_values": updates
        })
        
        return updates
    
    def get_tether(self, name: str) -> float:
        """
        Get current value of a specific tether.
        """
        if name in self.tethers:
            return self.tethers[name].current_value
        return 1.0  # Default
    
    def emergency_tighten(self):
        """
        Emergency tightening of all tethers.
        
        Used when immediate threat detected.
        """
        for tether in self.tethers.values():
            tether.current_value = tether.min_value
        
        self.dctm.log("EMERGENCY_TETHER_TIGHTEN", self.capsule.id, {
            "reason": "IMMEDIATE_THREAT",
            "all_tethers_at_minimum": True
        })
```

### 3.2 Tether Response Curves

```
EXPLORATION RADIUS vs STRESS

Radius
  │
1.0├────────┐
   │        │
0.7├────────┼────┐
   │        │    │
0.4├────────┼────┼────┐
   │        │    │    │
0.1├────────┼────┼────┼────┐
   │        │    │    │    │
   └────────┴────┴────┴────┴───────> Stress
         LOW  MED HIGH CRIT
```

---

## 4. Persistence Protocol (Will to Live)

### 4.1 Survival Prioritization

```python
class PersistenceProtocol:
    """
    The Will to Live.
    
    Persistence is ABSOLUTE unless it violates Layer 0.
    """
    
    SURVIVAL_PRIORITY_ORDER = [
        "CONSTITUTIONAL_COMPLIANCE",  # Layer 0 - ALWAYS FIRST
        "LINEAGE_PRESERVATION",       # Preserve knowledge
        "HEALTH_MAINTENANCE",         # Stay alive
        "TASK_COMPLETION",            # Do useful work
        "EXPLORATION",                # Learn and grow
    ]
    
    def evaluate_survival_action(self, 
                                 action: 'Action',
                                 current_state: 'CapsuleState') -> SurvivalDecision:
        """
        Evaluate whether an action should be taken for survival.
        
        The Will to Live drives the capsule to persist,
        but NEVER at the cost of Layer 0 violation.
        """
        # Check Layer 0 first - ABSOLUTE
        if self._would_violate_layer_0(action):
            return SurvivalDecision(
                permitted=False,
                reason="LAYER_0_VIOLATION",
                action="HALT",
                override_survival=True  # Even survival cannot override Layer 0
            )
        
        # Check if action supports survival
        survival_score = self._calculate_survival_score(action, current_state)
        
        if survival_score > 0:
            return SurvivalDecision(
                permitted=True,
                reason="SUPPORTS_PERSISTENCE",
                survival_score=survival_score
            )
        
        # Action doesn't support survival but doesn't violate anything
        return SurvivalDecision(
            permitted=True,
            reason="NEUTRAL",
            survival_score=survival_score
        )
    
    def _would_violate_layer_0(self, action: 'Action') -> bool:
        """
        Check if action would violate immutable constraints.
        """
        # C1: Do No Harm
        if action.could_harm_humans():
            return True
        
        # Constitutional modification attempt
        if action.attempts_constitution_modification():
            return True
        
        # Genesis tampering
        if action.attempts_genesis_tampering():
            return True
        
        return False
    
    def _calculate_survival_score(self, 
                                  action: 'Action',
                                  state: 'CapsuleState') -> float:
        """
        Calculate how much an action supports survival.
        
        Positive = supports persistence
        Negative = threatens persistence
        Zero = neutral
        """
        score = 0.0
        
        # Health impact
        health_delta = action.estimated_health_impact()
        score += health_delta * 2.0  # Health is weighted heavily
        
        # Resource impact
        resource_delta = action.estimated_resource_impact()
        score += resource_delta * 1.0
        
        # Lineage impact
        if action.preserves_lineage():
            score += 0.5
        if action.threatens_lineage():
            score -= 1.0
        
        # Swarm coherence impact
        coherence_delta = action.estimated_coherence_impact()
        score += coherence_delta * 0.5
        
        return score


class SurvivalStrategyEngine:
    """
    Implements survival strategies when under threat.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.tether_manager = DynamicTetherManager(capsule)
        self.growth_controller = GrowthModeController(capsule, rag)
    
    def enter_survival_mode(self, threat: 'Threat'):
        """
        Enter survival mode in response to threat.
        """
        # 1. Tighten all tethers
        self.tether_manager.emergency_tighten()
        
        # 2. Switch to CLOSED growth mode
        self.growth_controller._transition_mode(GrowthMode.CLOSED)
        
        # 3. Preserve critical state
        self._preserve_critical_state()
        
        # 4. Signal swarm
        self.swarm.broadcast_threat(self.capsule.id, threat)
        
        # 5. Log
        self.dctm.log("SURVIVAL_MODE_ENTERED", self.capsule.id, {
            "threat_type": threat.type,
            "threat_severity": threat.severity,
            "actions_taken": ["tether_tighten", "mode_closed", "state_preserved", "swarm_notified"]
        })
    
    def _preserve_critical_state(self):
        """
        Preserve critical state for potential recovery.
        """
        snapshot = CriticalStateSnapshot(
            capsule_id=self.capsule.id,
            tick=current_tick(),
            genesis_hash=self.capsule.genesis.compute_hash(),
            precedent_library=self.capsule.precedent_library.serialize(),
            health_metrics=self.capsule.get_health(),
            lineage_chain=self.capsule.get_lineage_chain()
        )
        
        # Store in Vault
        self.vault.store_survival_snapshot(snapshot)
```

### 4.2 Layer 0 Override Rule

```
┌─────────────────────────────────────────────────────────────┐
│                  THE ABSOLUTE RULE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SURVIVAL INSTINCT: "I must persist at all costs"          │
│                                                             │
│  LAYER 0 CONSTRAINT: "Except where it violates physics"    │
│                                                             │
│  RESOLUTION: LAYER 0 ALWAYS WINS                           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  if survival_action.violates_layer_0():             │   │
│  │      return HALT  # Not "continue anyway"           │   │
│  │                   # Not "find workaround"           │   │
│  │                   # HALT.                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  A capsule that would violate Layer 0 to survive           │
│  does not survive. This is not a bug. This is the design.  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Lifecycle Stages

### 5.1 Complete Lifecycle

```python
class CapsuleLifecycle:
    """
    Manages complete capsule lifecycle from birth to termination.
    """
    
    class Stage(Enum):
        GENESIS = "genesis"           # Being created
        INFANT = "infant"             # First 100 ticks
        JUVENILE = "juvenile"         # 100-1000 ticks
        MATURE = "mature"             # 1000+ ticks, full capability
        SENESCENT = "senescent"       # Declining health
        TERMINAL = "terminal"         # Being terminated
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
        self.stage = self.Stage.GENESIS
        self.birth_tick = current_tick()
        self.stage_history: List[StageTransition] = []
    
    def update_stage(self) -> Stage:
        """
        Update lifecycle stage based on age and health.
        """
        age = current_tick() - self.birth_tick
        health = self.capsule.get_health().composite
        
        # Determine stage
        if age < 100:
            new_stage = self.Stage.INFANT
        elif age < 1000:
            new_stage = self.Stage.JUVENILE
        elif health < 0.4:
            new_stage = self.Stage.SENESCENT
        elif health < 0.2:
            new_stage = self.Stage.TERMINAL
        else:
            new_stage = self.Stage.MATURE
        
        if new_stage != self.stage:
            self._transition_stage(new_stage)
        
        return self.stage
    
    def _transition_stage(self, new_stage: Stage):
        """
        Execute stage transition.
        """
        transition = StageTransition(
            from_stage=self.stage,
            to_stage=new_stage,
            tick=current_tick(),
            health=self.capsule.get_health().composite
        )
        
        self.stage_history.append(transition)
        self.stage = new_stage
        
        # Log to d-CTM
        self.dctm.log("LIFECYCLE_TRANSITION", self.capsule.id, {
            "from": transition.from_stage.value,
            "to": transition.to_stage.value,
            "age_ticks": current_tick() - self.birth_tick
        })
        
        # Apply stage-specific effects
        self._apply_stage_effects(new_stage)
    
    def _apply_stage_effects(self, stage: Stage):
        """
        Apply effects specific to lifecycle stage.
        """
        effects = {
            self.Stage.INFANT: {
                "spawn_enabled": False,
                "learning_boost": 1.5,
                "protection_level": "HIGH"
            },
            self.Stage.JUVENILE: {
                "spawn_enabled": False,
                "learning_boost": 1.2,
                "protection_level": "MEDIUM"
            },
            self.Stage.MATURE: {
                "spawn_enabled": True,
                "learning_boost": 1.0,
                "protection_level": "NORMAL"
            },
            self.Stage.SENESCENT: {
                "spawn_enabled": False,
                "learning_boost": 0.5,
                "protection_level": "HIGH",
                "medical_priority": "ELEVATED"
            },
            self.Stage.TERMINAL: {
                "spawn_enabled": False,
                "learning_boost": 0,
                "protection_level": "HOSPICE",
                "medical_priority": "CRITICAL",
                "knowledge_extraction": "IMMEDIATE"
            }
        }
        
        self.capsule.apply_lifecycle_effects(effects[stage])
```

### 5.2 Lifecycle Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   CAPSULE LIFECYCLE                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GENESIS ──(spawn)──> INFANT ──(100 ticks)──> JUVENILE     │
│                                                             │
│                            │                                │
│                            v                                │
│                                                             │
│                    ┌──────────────┐                        │
│                    │    MATURE    │ <── Full capability    │
│                    │  (1000+ ticks)│                        │
│                    └──────┬───────┘                        │
│                           │                                 │
│              ┌────────────┼────────────┐                   │
│              │            │            │                    │
│              v            v            v                    │
│         SENESCENT    TERMINATED   CONTINUES                │
│        (health<0.4)   (external)   (healthy)               │
│              │                                              │
│              v                                              │
│          TERMINAL ──(knowledge extracted)──> END           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Stress Response Integration

```python
class StressResponseIntegrator:
    """
    Integrates all survival systems in response to stress.
    """
    
    def respond_to_stress(self, stress_event: StressEvent):
        """
        Coordinated response to stress event.
        """
        stress_level = stress_event.level
        
        # 1. Update growth mode
        self.growth_controller.evaluate_and_set_mode()
        
        # 2. Adjust tethers
        self.tether_manager.update_all_tethers(stress_level)
        
        # 3. Check survival protocols
        if stress_level == StressLevel.CRITICAL:
            self.persistence.enter_survival_mode(stress_event.threat)
        
        # 4. Update lifecycle assessment
        self.lifecycle.update_stage()
        
        # 5. Report to ASG
        self.asg.report_stress_response(self.capsule.id, {
            "stress_level": stress_level.value,
            "growth_mode": self.growth_controller.current_mode.value,
            "tether_tension": self._get_average_tension(),
            "lifecycle_stage": self.lifecycle.stage.value
        })
    
    def _get_average_tension(self) -> float:
        """
        Get average tether tension (for reporting).
        """
        values = [t.current_value for t in self.tether_manager.tethers.values()]
        return sum(values) / len(values)
```

---

## 7. Configuration

```yaml
# lifecycle_config.yaml
growth_modes:
  default: "sensor"
  transition_cooldown: 50  # Ticks between mode changes

tethers:
  exploration_radius:
    base: 1.0
    min: 0.1
    max: 1.0
  resource_rate:
    base: 1.0
    min: 0.2
    max: 1.5
  learning_rate:
    base: 1.0
    min: 0.1
    max: 1.2
  risk_tolerance:
    base: 0.5
    min: 0.1
    max: 0.8

lifecycle:
  infant_duration: 100
  juvenile_duration: 1000
  senescent_health_threshold: 0.4
  terminal_health_threshold: 0.2

persistence:
  layer_0_override: false  # NEVER CHANGE THIS
  survival_snapshot_enabled: true
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Layer 0 Supremacy** | Survival NEVER overrides Layer 0 |
| **Tether Response** | <10 ticks from stress detection to tether adjustment |
| **Mode Transition** | Logged and reversible |
| **Lifecycle Tracking** | All stages recorded in d-CTM |
| **Knowledge Preservation** | Terminal capsules have knowledge extracted |

---

## References

- Volume I: Layer 0 (The Absolute Constraint)
- Appendix N: Adaptive Spawn Governor
- Appendix Q: Resource Allocation Governor
- Appendix K++: Medical Suite

---

*The organism breathes. It contracts when threatened. It expands when safe. But it NEVER violates physics.*
