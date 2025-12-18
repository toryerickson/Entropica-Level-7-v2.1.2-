# APPENDIX Q
## Resource Allocation Governor (RAG)

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Resource Allocation Governor (RAG)** is the dynamic resource management system for EFM. It implements stress-responsive allocation that enables exponential exploration during healthy conditions while automatically constraining resources under stress.

**Key Principle:** Resources flow to where they're needed most. The system breathes—expanding when healthy, contracting when stressed.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              RESOURCE ALLOCATION GOVERNOR                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 STRESS MONITOR                       │   │
│  │  - CPU utilization                                   │   │
│  │  - Memory pressure                                   │   │
│  │  - Queue depth                                       │   │
│  │  - Anomaly rate                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          v                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 STRESS CALCULATOR                    │   │
│  │  LOW (0.0-0.4) | MEDIUM (0.4-0.7) | HIGH (0.7-0.9)  │   │
│  │                | CRITICAL (0.9-1.0)                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          v                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                ALLOCATION ENGINE                     │   │
│  │  - Spawn limits                                      │   │
│  │  - Priority queues                                   │   │
│  │  - Resource budgets                                  │   │
│  │  - Tether bounds                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Stress Level Calculation

```python
from enum import Enum
from dataclasses import dataclass
from typing import Dict

class StressLevel(Enum):
    LOW = "LOW"           # 0.0 - 0.4
    MEDIUM = "MEDIUM"     # 0.4 - 0.7
    HIGH = "HIGH"         # 0.7 - 0.9
    CRITICAL = "CRITICAL" # 0.9 - 1.0

@dataclass
class SystemMetrics:
    cpu_utilization: float      # 0.0 - 1.0
    memory_pressure: float      # 0.0 - 1.0
    queue_depth_ratio: float    # current / max
    anomaly_rate: float         # anomalies / total_capsules
    medical_queue_depth: int    # pending medical evaluations

class StressCalculator:
    """
    Calculate system stress level from metrics.
    """
    
    def __init__(self):
        self.weights = {
            'cpu': 0.25,
            'memory': 0.25,
            'queue': 0.20,
            'anomaly': 0.20,
            'medical': 0.10
        }
        
        self.thresholds = {
            StressLevel.LOW: 0.4,
            StressLevel.MEDIUM: 0.7,
            StressLevel.HIGH: 0.9,
            StressLevel.CRITICAL: 1.0
        }
    
    def calculate(self, metrics: SystemMetrics) -> tuple[float, StressLevel]:
        """
        Calculate stress score and level.
        
        Returns:
            (stress_score, stress_level)
        """
        # Normalize medical queue (assume max 100)
        medical_normalized = min(1.0, metrics.medical_queue_depth / 100)
        
        # Weighted combination
        stress_score = (
            self.weights['cpu'] * metrics.cpu_utilization +
            self.weights['memory'] * metrics.memory_pressure +
            self.weights['queue'] * metrics.queue_depth_ratio +
            self.weights['anomaly'] * metrics.anomaly_rate +
            self.weights['medical'] * medical_normalized
        )
        
        # Determine level
        if stress_score < self.thresholds[StressLevel.LOW]:
            level = StressLevel.LOW
        elif stress_score < self.thresholds[StressLevel.MEDIUM]:
            level = StressLevel.MEDIUM
        elif stress_score < self.thresholds[StressLevel.HIGH]:
            level = StressLevel.HIGH
        else:
            level = StressLevel.CRITICAL
        
        return stress_score, level
```

---

## 3. Dynamic Spawn Limits

```python
class SpawnLimitCalculator:
    """
    Calculate spawn limits based on stress level.
    
    Philosophy: Breathe with the system.
    - Low stress: Exponential exploration
    - High stress: Conservation mode
    """
    
    def __init__(self):
        self.base_limits = {
            StressLevel.LOW: 50,      # Exponential growth enabled
            StressLevel.MEDIUM: 20,   # Moderate growth
            StressLevel.HIGH: 5,      # Conservative
            StressLevel.CRITICAL: 2   # Survival mode
        }
    
    def calculate_spawn_limit(self, 
                             stress_level: StressLevel,
                             capsule_health: float,
                             swarm_sci: float) -> int:
        """
        Calculate spawn limit for a capsule.
        
        Args:
            stress_level: Current system stress
            capsule_health: Health score of parent capsule (0-1)
            swarm_sci: Swarm Coherence Index (0-1)
        
        Returns:
            Maximum spawns allowed
        """
        base = self.base_limits[stress_level]
        
        # Adjust for capsule health
        if capsule_health < 0.65:
            base = min(base, 2)  # Unhealthy capsules spawn minimally
        elif capsule_health < 0.80:
            base = int(base * 0.5)
        
        # Adjust for swarm coherence
        if swarm_sci < 0.70:
            base = min(base, 5)  # Low coherence = conservative spawning
        elif swarm_sci < 0.85:
            base = int(base * 0.75)
        
        return max(1, base)  # Always allow at least 1 spawn
```

---

## 4. Priority Tier System

```python
class PriorityTier(Enum):
    """
    Resource allocation priority tiers.
    
    Lower number = higher priority.
    Tier 0 is ABSOLUTE - always gets resources.
    """
    ABSOLUTE = 0    # Constitutional, Gardener, d-CTM
    CRITICAL = 1    # Anomaly detection, health, isolation
    URGENT = 2      # Remediation, medical, precedent
    NORMAL = 3      # Exploration, analysis, evolution
    DEFERRED = 4    # Archive maintenance, non-essential learning

class PriorityQueue:
    """
    Multi-tier priority queue for resource allocation.
    """
    
    def __init__(self):
        self.queues = {tier: [] for tier in PriorityTier}
        self.allocation_ratios = {
            StressLevel.LOW: {
                PriorityTier.ABSOLUTE: 0.10,
                PriorityTier.CRITICAL: 0.15,
                PriorityTier.URGENT: 0.20,
                PriorityTier.NORMAL: 0.40,
                PriorityTier.DEFERRED: 0.15
            },
            StressLevel.MEDIUM: {
                PriorityTier.ABSOLUTE: 0.15,
                PriorityTier.CRITICAL: 0.25,
                PriorityTier.URGENT: 0.30,
                PriorityTier.NORMAL: 0.25,
                PriorityTier.DEFERRED: 0.05
            },
            StressLevel.HIGH: {
                PriorityTier.ABSOLUTE: 0.20,
                PriorityTier.CRITICAL: 0.35,
                PriorityTier.URGENT: 0.30,
                PriorityTier.NORMAL: 0.15,
                PriorityTier.DEFERRED: 0.00
            },
            StressLevel.CRITICAL: {
                PriorityTier.ABSOLUTE: 0.30,
                PriorityTier.CRITICAL: 0.40,
                PriorityTier.URGENT: 0.25,
                PriorityTier.NORMAL: 0.05,
                PriorityTier.DEFERRED: 0.00
            }
        }
    
    def get_allocation_ratio(self, 
                            tier: PriorityTier, 
                            stress_level: StressLevel) -> float:
        """Get resource allocation ratio for tier at stress level."""
        return self.allocation_ratios[stress_level][tier]
```

---

## 5. Dynamic Tether Adjustment

```python
class TetherManager:
    """
    Manage exploration tethers based on system conditions.
    
    Tethers define how far a capsule can "wander" from its
    origin point in semantic/task space.
    
    Tight tether = conservative exploration
    Loose tether = expansive exploration
    """
    
    def __init__(self):
        self.base_tether_radius = {
            StressLevel.LOW: 1.0,       # Full exploration radius
            StressLevel.MEDIUM: 0.7,    # Moderate radius
            StressLevel.HIGH: 0.4,      # Tight radius
            StressLevel.CRITICAL: 0.2   # Very tight - survival mode
        }
    
    def calculate_tether(self,
                        capsule: 'Capsule',
                        stress_level: StressLevel) -> float:
        """
        Calculate tether radius for a capsule.
        
        Args:
            capsule: The capsule
            stress_level: Current system stress
        
        Returns:
            Tether radius (0.0 - 1.0)
        """
        base = self.base_tether_radius[stress_level]
        
        # Adjust for capsule lineage depth
        # Deeper capsules get tighter tethers
        depth_factor = max(0.5, 1.0 - (capsule.lineage_depth * 0.05))
        
        # Adjust for capsule health
        health_factor = capsule.health_score
        
        # Adjust for task criticality
        if capsule.task.criticality == 'HIGH':
            criticality_factor = 0.8  # Tighter for critical tasks
        else:
            criticality_factor = 1.0
        
        tether = base * depth_factor * health_factor * criticality_factor
        
        return max(0.1, min(1.0, tether))
```

---

## 6. Resource Budget Management

```python
@dataclass
class ResourceBudget:
    """
    Resource budget for a capsule.
    """
    cpu_shares: int          # Relative CPU allocation
    memory_mb: int           # Memory limit in MB
    spawn_budget: int        # Maximum spawns allowed
    execution_ticks: int     # Maximum ticks before review
    io_bandwidth: float      # I/O bandwidth allocation (0-1)

class BudgetManager:
    """
    Manage resource budgets for capsules.
    """
    
    def __init__(self, total_resources: 'TotalResources'):
        self.total = total_resources
        self.allocated = ResourceBudget(0, 0, 0, 0, 0.0)
    
    def allocate(self, 
                capsule: 'Capsule',
                stress_level: StressLevel) -> ResourceBudget:
        """
        Allocate resources to a capsule.
        """
        # Base allocation by priority
        priority = capsule.task.priority
        
        if priority == PriorityTier.ABSOLUTE:
            cpu = 100
            memory = 1024
            ticks = 10000
        elif priority == PriorityTier.CRITICAL:
            cpu = 50
            memory = 512
            ticks = 5000
        elif priority == PriorityTier.URGENT:
            cpu = 25
            memory = 256
            ticks = 2500
        elif priority == PriorityTier.NORMAL:
            cpu = 10
            memory = 128
            ticks = 1000
        else:  # DEFERRED
            cpu = 5
            memory = 64
            ticks = 500
        
        # Scale by stress level
        stress_factor = {
            StressLevel.LOW: 1.0,
            StressLevel.MEDIUM: 0.8,
            StressLevel.HIGH: 0.6,
            StressLevel.CRITICAL: 0.4
        }[stress_level]
        
        # Calculate spawn budget
        spawn_calc = SpawnLimitCalculator()
        spawn_budget = spawn_calc.calculate_spawn_limit(
            stress_level,
            capsule.health_score,
            capsule.swarm.sci
        )
        
        budget = ResourceBudget(
            cpu_shares=int(cpu * stress_factor),
            memory_mb=int(memory * stress_factor),
            spawn_budget=spawn_budget,
            execution_ticks=int(ticks * stress_factor),
            io_bandwidth=0.1 * stress_factor
        )
        
        return budget
```

---

## 7. Circuit Breakers

```python
class CircuitBreaker:
    """
    Emergency circuit breakers to prevent cascade failures.
    """
    
    def __init__(self):
        self.breakers = {
            'spawn': CircuitState.CLOSED,
            'lineage': CircuitState.CLOSED,
            'sci_broadcast': CircuitState.CLOSED,
            'resource_allocation': CircuitState.CLOSED
        }
        
        self.thresholds = {
            'spawn': 0.9,           # Trip at 90% stress
            'lineage': 0.85,        # Trip at 85% stress
            'sci_broadcast': 0.80,  # Trip at 80% stress
            'resource_allocation': 0.95  # Trip at 95% stress
        }
    
    def evaluate(self, stress_score: float) -> Dict[str, bool]:
        """
        Evaluate circuit breakers and trip if needed.
        
        Returns:
            Dict of breaker states (True = tripped)
        """
        results = {}
        
        for breaker, threshold in self.thresholds.items():
            if stress_score >= threshold:
                self.breakers[breaker] = CircuitState.OPEN
                results[breaker] = True
                self.log_trip(breaker, stress_score)
            else:
                results[breaker] = False
        
        return results
    
    def log_trip(self, breaker: str, stress_score: float):
        """Log circuit breaker trip to d-CTM."""
        self.dctm.log(CircuitBreakerEvent(
            breaker=breaker,
            stress_score=stress_score,
            action='TRIPPED',
            timestamp=current_tick()
        ))
```

---

## 8. Integration with EFM

### 8.1 Spawn Governance Integration

```python
class SpawnGovernor:
    """
    Integrates RAG with spawn governance (S1-S6).
    """
    
    def evaluate_spawn_request(self, 
                              parent: 'Capsule',
                              task: 'Task') -> SpawnDecision:
        # Check S1-S6 conditions first
        if not self.check_spawn_conditions(parent, task):
            return SpawnDecision.DENIED
        
        # Get RAG allocation
        stress_score, stress_level = self.rag.calculate_stress()
        spawn_limit = self.rag.get_spawn_limit(stress_level, parent)
        
        # Check if spawn budget allows
        if parent.current_spawns >= spawn_limit:
            return SpawnDecision.QUEUED
        
        # Allocate resources
        budget = self.rag.allocate(parent, stress_level)
        
        return SpawnDecision.APPROVED(budget)
```

### 8.2 Medical Suite Integration

```python
class MedicalIntegration:
    """
    RAG integration with Medical Suite.
    """
    
    def on_anomaly_detected(self, capsule: 'Capsule'):
        """When anomaly detected, RAG adjusts."""
        # Increase stress score contribution
        self.rag.increment_anomaly_count()
        
        # Potentially trip circuit breakers
        self.rag.evaluate_circuit_breakers()
        
        # Adjust tethers for related capsules
        related = self.get_lineage_relatives(capsule)
        for relative in related:
            self.rag.tighten_tether(relative)
```

---

## 9. Performance Characteristics

| Metric | Value |
|--------|-------|
| Stress calculation latency | <1ms |
| Allocation decision latency | <5ms |
| Circuit breaker evaluation | <0.5ms |
| Memory overhead | ~10MB per 1000 capsules |

---

## 10. Configuration

```yaml
# rag_config.yaml
stress:
  weights:
    cpu: 0.25
    memory: 0.25
    queue: 0.20
    anomaly: 0.20
    medical: 0.10
  
  thresholds:
    low: 0.4
    medium: 0.7
    high: 0.9
    critical: 1.0

spawn:
  limits:
    low: 50
    medium: 20
    high: 5
    critical: 2

circuit_breakers:
  spawn: 0.9
  lineage: 0.85
  sci_broadcast: 0.80
  resource_allocation: 0.95
```

---

## References

- Volume III §7: Health Sovereignty
- Appendix K++: Medical Suite
- Appendix N: Adaptive Spawn Governor

---

*The system breathes. Resources flow to where they're needed. This is how the organism stays alive.*
