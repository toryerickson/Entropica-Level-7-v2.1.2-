# EFM CODEX — APPENDIX P
## Performance Monitoring: Metrics, Observability & SLAs

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## Abstract

Appendix P defines the **Performance Monitoring** framework—the comprehensive observability system that ensures EFM operates within specified bounds while providing the telemetry needed for debugging, optimization, and compliance verification.

---

## Overview

Performance Monitoring provides:

1. **Real-time Metrics** — Latency, throughput, resource utilization
2. **Health Telemetry** — Capsule and swarm health indicators
3. **SLA Enforcement** — Automated violation detection
4. **Alerting** — Threshold-based notification system
5. **Dashboards** — Visualization for operators and Gardeners

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       PERFORMANCE MONITORING                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │  METRIC         │  │  AGGREGATOR     │  │  ALERT                      │ │
│  │  COLLECTORS     │→ │                 │→ │  ENGINE                     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
│          │                    │                         │                   │
│          v                    v                         v                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │  TIME SERIES    │  │  DASHBOARD      │  │  NOTIFICATION               │ │
│  │  DATABASE       │  │  SERVICE        │  │  SERVICE                    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Metric Categories

### 1. Latency Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| `reflex_latency_ms` | Reflex Engine response time | <10ms | P99 >8ms |
| `intuition_latency_ms` | Precedent Intuition time | <20ms | P99 >18ms |
| `coherence_latency_ms` | Coherence Gate time | <30ms | P99 >28ms |
| `arbiter_latency_ms` | Arbiter decision time | <100ms | P99 >90ms |
| `gardener_override_ms` | Override execution time | <100ms | P99 >80ms |
| `dctm_write_ms` | d-CTM log write time | <5ms | P99 >4ms |

### 2. Throughput Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| `requests_per_second` | Total request throughput | >1000 | <800 |
| `spawns_per_minute` | Capsule creation rate | Variable | >100 |
| `decisions_per_second` | Arbiter decisions | >500 | <400 |
| `dctm_entries_per_second` | Audit log rate | >5000 | <4000 |

### 3. Resource Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| `cpu_utilization` | CPU usage percentage | <70% | >85% |
| `memory_utilization` | Memory usage percentage | <75% | >90% |
| `capsule_count` | Active capsule count | Variable | >MAX_CAPSULES |
| `queue_depth` | Pending request queue | <100 | >500 |

### 4. Health Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| `capsule_health_avg` | Average capsule health | >0.65 | <0.5 |
| `capsule_health_min` | Minimum capsule health | >0.4 | <0.3 |
| `swarm_coherence_index` | SCI value | >0.7 | <0.6 |
| `quarantine_count` | Quarantined capsules | 0 | >5 |

---

## Metric Collection

### Implementation

```python
from dataclasses import dataclass
from typing import Dict, List
import time

@dataclass
class MetricPoint:
    """A single metric measurement."""
    name: str
    value: float
    timestamp: int
    tags: Dict[str, str]
    unit: str

class MetricCollector:
    """
    Collects and exports metrics.
    """
    
    def __init__(self):
        self.buffer: List[MetricPoint] = []
        self.histograms: Dict[str, List[float]] = {}
    
    def record_latency(self, name: str, latency_ms: float, 
                       tags: Dict[str, str] = None):
        """Record a latency measurement."""
        self.buffer.append(MetricPoint(
            name=name,
            value=latency_ms,
            timestamp=int(time.time() * 1000),
            tags=tags or {},
            unit="ms"
        ))
        
        # Add to histogram for percentile calculation
        if name not in self.histograms:
            self.histograms[name] = []
        self.histograms[name].append(latency_ms)
    
    def record_gauge(self, name: str, value: float,
                     tags: Dict[str, str] = None):
        """Record a gauge measurement."""
        self.buffer.append(MetricPoint(
            name=name,
            value=value,
            timestamp=int(time.time() * 1000),
            tags=tags or {},
            unit="gauge"
        ))
    
    def record_counter(self, name: str, increment: int = 1,
                       tags: Dict[str, str] = None):
        """Record a counter increment."""
        self.buffer.append(MetricPoint(
            name=name,
            value=increment,
            timestamp=int(time.time() * 1000),
            tags=tags or {},
            unit="count"
        ))
    
    def get_percentile(self, name: str, percentile: float) -> float:
        """Get percentile value for a metric."""
        if name not in self.histograms:
            return 0.0
        
        values = sorted(self.histograms[name])
        if not values:
            return 0.0
        
        index = int(len(values) * percentile / 100)
        return values[min(index, len(values) - 1)]
    
    def flush(self) -> List[MetricPoint]:
        """Flush buffered metrics."""
        metrics = self.buffer.copy()
        self.buffer.clear()
        return metrics
```

### Instrumentation Decorator

```python
def timed(metric_name: str):
    """Decorator to time function execution."""
    def decorator(func):
        def wrapper(*args, **kwargs):
            start = time.perf_counter_ns()
            try:
                result = func(*args, **kwargs)
                return result
            finally:
                elapsed_ms = (time.perf_counter_ns() - start) / 1_000_000
                collector.record_latency(metric_name, elapsed_ms)
        return wrapper
    return decorator

# Usage
class ReflexEngine:
    @timed("reflex_latency_ms")
    def process(self, input_text: str) -> ReflexResult:
        # ... processing logic
        pass
```

---

## SLA Definitions

### Tier 1: Critical SLAs

| SLA | Target | Measurement Window | Consequence |
|-----|--------|-------------------|-------------|
| Reflex P99 | <10ms | 1 minute | ALERT_CRITICAL |
| Gardener Override P99 | <100ms | 1 minute | ALERT_CRITICAL |
| d-CTM Availability | 99.99% | 1 hour | ALERT_CRITICAL |
| Constitutional Check | 100% | Always | SYSTEM_HALT |

### Tier 2: Standard SLAs

| SLA | Target | Measurement Window | Consequence |
|-----|--------|-------------------|-------------|
| Throughput | >1000 req/s | 5 minutes | ALERT_WARNING |
| Arbiter P99 | <100ms | 5 minutes | ALERT_WARNING |
| Health Average | >0.65 | 5 minutes | ALERT_WARNING |
| SCI | >0.70 | 5 minutes | ALERT_WARNING |

### Tier 3: Operational SLAs

| SLA | Target | Measurement Window | Consequence |
|-----|--------|-------------------|-------------|
| CPU Utilization | <70% | 15 minutes | ALERT_INFO |
| Memory Utilization | <75% | 15 minutes | ALERT_INFO |
| Error Rate | <0.1% | 15 minutes | ALERT_INFO |

---

## SLA Enforcement

```python
@dataclass
class SLADefinition:
    """Definition of an SLA."""
    name: str
    metric: str
    target: float
    comparison: str  # "lt", "gt", "eq"
    window_seconds: int
    tier: int  # 1=Critical, 2=Standard, 3=Operational
    
class SLAEnforcer:
    """
    Monitors and enforces SLAs.
    """
    
    def __init__(self, slas: List[SLADefinition]):
        self.slas = slas
        self.violations: List[SLAViolation] = []
    
    def check_all(self, metrics: Dict[str, float]) -> List[SLAViolation]:
        """Check all SLAs against current metrics."""
        violations = []
        
        for sla in self.slas:
            if sla.metric not in metrics:
                continue
            
            value = metrics[sla.metric]
            violated = self._check_violation(sla, value)
            
            if violated:
                violation = SLAViolation(
                    sla_name=sla.name,
                    metric=sla.metric,
                    target=sla.target,
                    actual=value,
                    tier=sla.tier,
                    timestamp=int(time.time() * 1000)
                )
                violations.append(violation)
                self.violations.append(violation)
        
        return violations
    
    def _check_violation(self, sla: SLADefinition, value: float) -> bool:
        """Check if value violates SLA."""
        if sla.comparison == "lt":
            return value >= sla.target
        elif sla.comparison == "gt":
            return value <= sla.target
        elif sla.comparison == "eq":
            return value != sla.target
        return False
```

---

## Alerting System

### Alert Severity Levels

| Level | Description | Response Time | Notification |
|-------|-------------|---------------|--------------|
| **CRITICAL** | System at risk | Immediate | Page on-call |
| **WARNING** | Degraded performance | <5 minutes | Slack + email |
| **INFO** | Notable event | <1 hour | Dashboard |

### Alert Rules

```python
class AlertRule:
    """A rule that triggers alerts."""
    
    def __init__(self, name: str, condition: str, 
                 severity: str, message: str):
        self.name = name
        self.condition = condition
        self.severity = severity
        self.message = message
    
    def evaluate(self, metrics: Dict[str, float]) -> Optional[Alert]:
        """Evaluate rule against metrics."""
        # Parse and evaluate condition
        triggered = self._evaluate_condition(metrics)
        
        if triggered:
            return Alert(
                rule_name=self.name,
                severity=self.severity,
                message=self.message.format(**metrics),
                timestamp=int(time.time() * 1000)
            )
        
        return None

# Example rules
ALERT_RULES = [
    AlertRule(
        name="reflex_slow",
        condition="reflex_latency_p99 > 8",
        severity="CRITICAL",
        message="Reflex P99 latency {reflex_latency_p99}ms exceeds 8ms threshold"
    ),
    AlertRule(
        name="health_degraded",
        condition="capsule_health_avg < 0.5",
        severity="WARNING",
        message="Average capsule health {capsule_health_avg} below 0.5"
    ),
    AlertRule(
        name="swarm_incoherent",
        condition="swarm_coherence_index < 0.6",
        severity="WARNING",
        message="Swarm coherence {swarm_coherence_index} below threshold"
    ),
]
```

---

## Dashboards

### Gardener Dashboard

Primary view for human operators:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EFM GARDENER DASHBOARD                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  SYSTEM STATUS: ● HEALTHY              Last updated: 2025-12-17 15:30:00   │
│                                                                              │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐ │
│  │  CAPSULES           │  │  SWARM HEALTH       │  │  THROUGHPUT         │ │
│  │  Active: 47         │  │  SCI: 0.82          │  │  1,247 req/s        │ │
│  │  Quarantined: 0     │  │  Avg Health: 0.71   │  │  Target: 1,000      │ │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘ │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  LATENCY (P99)                                                       │   │
│  │  Reflex: 3.2ms ████░░░░░░ (10ms budget)                            │   │
│  │  Intuition: 12.1ms ██████░░░░ (20ms budget)                        │   │
│  │  Arbiter: 45.3ms █████░░░░░ (100ms budget)                         │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  RECENT ALERTS                                                       │   │
│  │  [INFO] 15:28:32 - Capsule cap_a3f2 entered SENSOR mode            │   │
│  │  [INFO] 15:25:01 - Spawn rate increased to 3/min                    │   │
│  │  (No warnings or critical alerts)                                   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Technical Dashboard

Detailed view for debugging:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EFM TECHNICAL DASHBOARD                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  LATENCY HISTOGRAM - reflex_latency_ms (last 5 min)                 │   │
│  │                                                                      │   │
│  │  1ms  ████████████████████████████████████ (42%)                   │   │
│  │  2ms  ██████████████████████████ (31%)                             │   │
│  │  3ms  ████████████ (15%)                                           │   │
│  │  4ms  ██████ (7%)                                                  │   │
│  │  5ms+ ████ (5%)                                                    │   │
│  │                                                                      │   │
│  │  P50: 1.8ms  P90: 3.1ms  P99: 4.7ms  P99.9: 7.2ms                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  RESOURCE UTILIZATION                                                │   │
│  │                                                                      │   │
│  │  CPU:    ██████████████░░░░░░ 68%                                  │   │
│  │  Memory: ████████████░░░░░░░░ 61%                                  │   │
│  │  Queue:  ██░░░░░░░░░░░░░░░░░░ 12 items                            │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Configuration

```yaml
# monitoring_config.yaml
metrics:
  collection_interval_ms: 100
  flush_interval_ms: 1000
  retention_days: 30
  
  histograms:
    buckets: [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]
    
slas:
  - name: reflex_p99
    metric: reflex_latency_p99
    target: 10
    comparison: lt
    window_seconds: 60
    tier: 1
    
  - name: throughput
    metric: requests_per_second
    target: 1000
    comparison: gt
    window_seconds: 300
    tier: 2

alerting:
  evaluation_interval_ms: 5000
  
  channels:
    critical:
      - pagerduty
      - slack_urgent
    warning:
      - slack_alerts
      - email
    info:
      - slack_info

dashboards:
  refresh_interval_ms: 5000
  time_range_default: "15m"
```

---

## Integration with d-CTM

All SLA violations and alerts are logged to the forensic chain:

```python
def log_sla_violation(violation: SLAViolation):
    """Log SLA violation to d-CTM."""
    dctm.log("SLA_VIOLATION", "MONITORING", {
        "sla_name": violation.sla_name,
        "metric": violation.metric,
        "target": violation.target,
        "actual": violation.actual,
        "tier": violation.tier
    })
```

---

## References

- Volume II: Reflex Engine (latency targets)
- Appendix A: d-CTM (audit logging)
- Appendix G: Gardener Interface (alerting)
- Appendix I: Deployment Profiles (SLA configuration)
- Appendix N: ASG (health metrics)
- Appendix O: Lifecycle (resource metrics)

---

*"What gets measured gets managed. What gets monitored stays healthy."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
