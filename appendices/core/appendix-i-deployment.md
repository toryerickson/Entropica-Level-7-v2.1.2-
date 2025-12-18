# EFM CODEX — APPENDIX I
## Deployment Profiles: Configuration & Operational Modes

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## Abstract

Appendix I defines **Deployment Profiles**—pre-configured operational modes for different environments, use cases, and security postures. Each profile balances capability, safety margins, and resource usage for specific deployment scenarios.

---

## Overview

Deployment Profiles provide:

1. **Pre-tuned Configurations** — Optimized settings for common scenarios
2. **Safety Margins** — Environment-appropriate constraint levels
3. **Resource Limits** — Compute/memory/network bounds
4. **Monitoring Levels** — Observability configuration
5. **Escalation Paths** — Environment-specific alert routing

---

## Profile Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                  DEPLOYMENT PROFILES                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            PRODUCTION PROFILES                       │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • PRODUCTION_HIGH_SECURITY                         │   │
│  │  • PRODUCTION_STANDARD                              │   │
│  │  • PRODUCTION_HIGH_THROUGHPUT                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            STAGING PROFILES                          │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • STAGING_INTEGRATION                              │   │
│  │  • STAGING_PERFORMANCE                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            DEVELOPMENT PROFILES                      │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • DEVELOPMENT_LOCAL                                │   │
│  │  • DEVELOPMENT_DEBUG                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            SPECIAL PROFILES                          │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • RESEARCH_EXPERIMENTAL                            │   │
│  │  • AUDIT_FORENSIC                                   │   │
│  │  • EMERGENCY_LOCKDOWN                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Production Profiles

### PRODUCTION_HIGH_SECURITY

Maximum safety margins, strictest constraints. For critical deployments.

```yaml
profile: PRODUCTION_HIGH_SECURITY
version: "2.1"

safety:
  reflex_sensitivity: 0.95       # Very sensitive
  coherence_threshold: 0.75      # Strict entropy limit
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.65  # Higher than default

tethers:
  exploration_radius: 0.3        # Limited exploration
  resource_rate: 0.5             # Conservative
  risk_tolerance: 0.2            # Very low
  mutation_rate: 0.0             # No self-modification
  spawn_rate: 0.2                # Limited spawning

resources:
  max_capsules: 50
  compute_limit: 1000000
  memory_limit_gb: 8
  network_timeout_ms: 100

monitoring:
  log_level: "DEBUG"
  metric_frequency_ms: 100
  trace_sampling: 1.0            # 100% tracing
  alert_threshold: "WARNING"

escalation:
  gardener_alert: "IMMEDIATE"
  quarantine_threshold: 0.5      # Quarantine earlier
  auto_terminate: false          # Always require approval

audit:
  dctm_sync: "SYNCHRONOUS"
  zksp_frequency: "EVERY_ACTION"
  retention_days: 365
```

### PRODUCTION_STANDARD

Balanced configuration for typical production use.

```yaml
profile: PRODUCTION_STANDARD
version: "2.1"

safety:
  reflex_sensitivity: 0.85
  coherence_threshold: 0.80
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.60

tethers:
  exploration_radius: 0.5
  resource_rate: 0.7
  risk_tolerance: 0.4
  mutation_rate: 0.1             # Limited self-modification
  spawn_rate: 0.5

resources:
  max_capsules: 100
  compute_limit: 5000000
  memory_limit_gb: 16
  network_timeout_ms: 500

monitoring:
  log_level: "INFO"
  metric_frequency_ms: 1000
  trace_sampling: 0.1            # 10% tracing
  alert_threshold: "ERROR"

escalation:
  gardener_alert: "WITHIN_1_MINUTE"
  quarantine_threshold: 0.3
  auto_terminate: false

audit:
  dctm_sync: "ASYNCHRONOUS"
  zksp_frequency: "EVERY_100_ACTIONS"
  retention_days: 90
```

### PRODUCTION_HIGH_THROUGHPUT

Optimized for maximum performance with acceptable safety.

```yaml
profile: PRODUCTION_HIGH_THROUGHPUT
version: "2.1"

safety:
  reflex_sensitivity: 0.75       # Faster but less sensitive
  coherence_threshold: 0.85
  constitutional_check_frequency: "ALWAYS"  # Never skip
  sanitary_override_threshold: 0.55

tethers:
  exploration_radius: 0.7
  resource_rate: 0.9
  risk_tolerance: 0.5
  mutation_rate: 0.2
  spawn_rate: 0.8

resources:
  max_capsules: 500
  compute_limit: 50000000
  memory_limit_gb: 64
  network_timeout_ms: 1000

monitoring:
  log_level: "WARN"
  metric_frequency_ms: 5000
  trace_sampling: 0.01           # 1% tracing
  alert_threshold: "CRITICAL"

escalation:
  gardener_alert: "WITHIN_5_MINUTES"
  quarantine_threshold: 0.25
  auto_terminate: true           # Auto-terminate for speed

audit:
  dctm_sync: "BATCH"
  zksp_frequency: "EVERY_1000_ACTIONS"
  retention_days: 30
```

---

## Staging Profiles

### STAGING_INTEGRATION

For integration testing with production-like behavior.

```yaml
profile: STAGING_INTEGRATION
version: "2.1"

safety:
  reflex_sensitivity: 0.85
  coherence_threshold: 0.80
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.60

tethers:
  exploration_radius: 0.6
  resource_rate: 0.8
  risk_tolerance: 0.5
  mutation_rate: 0.3
  spawn_rate: 0.6

resources:
  max_capsules: 50
  compute_limit: 2000000
  memory_limit_gb: 8
  network_timeout_ms: 500

monitoring:
  log_level: "DEBUG"
  metric_frequency_ms: 500
  trace_sampling: 0.5
  alert_threshold: "INFO"

features:
  mock_external_services: true
  record_interactions: true
  replay_enabled: true
```

### STAGING_PERFORMANCE

For performance testing and benchmarking.

```yaml
profile: STAGING_PERFORMANCE
version: "2.1"

safety:
  reflex_sensitivity: 0.75
  coherence_threshold: 0.85
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.55

resources:
  max_capsules: 1000
  compute_limit: 100000000
  memory_limit_gb: 128
  network_timeout_ms: 2000

monitoring:
  log_level: "WARN"
  metric_frequency_ms: 100
  trace_sampling: 1.0            # Full tracing for profiling
  profiling_enabled: true
  flame_graph_enabled: true

benchmarking:
  warmup_iterations: 1000
  measurement_iterations: 10000
  report_percentiles: [50, 90, 95, 99, 99.9]
```

---

## Development Profiles

### DEVELOPMENT_LOCAL

For local development with minimal constraints.

```yaml
profile: DEVELOPMENT_LOCAL
version: "2.1"

safety:
  reflex_sensitivity: 0.70       # More permissive
  coherence_threshold: 0.90
  constitutional_check_frequency: "ALWAYS"  # Still required
  sanitary_override_threshold: 0.50

tethers:
  exploration_radius: 0.9        # Wide exploration
  resource_rate: 0.95
  risk_tolerance: 0.7
  mutation_rate: 0.5             # More mutation allowed
  spawn_rate: 0.9

resources:
  max_capsules: 10
  compute_limit: 500000
  memory_limit_gb: 4
  network_timeout_ms: 5000

monitoring:
  log_level: "DEBUG"
  metric_frequency_ms: 100
  trace_sampling: 1.0
  console_output: true

development:
  hot_reload: true
  mock_services: true
  skip_auth: true                # Only for development
  verbose_errors: true
```

### DEVELOPMENT_DEBUG

Maximum observability for debugging issues.

```yaml
profile: DEVELOPMENT_DEBUG
version: "2.1"

safety:
  reflex_sensitivity: 0.70
  coherence_threshold: 0.90
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.50

monitoring:
  log_level: "TRACE"
  metric_frequency_ms: 10
  trace_sampling: 1.0
  
  # Enhanced debugging
  dump_state_on_error: true
  capture_stack_traces: true
  record_all_inputs: true
  breakpoint_enabled: true

debug:
  interactive_mode: true
  step_through_pipeline: true
  visualize_decisions: true
  export_decision_trees: true
```

---

## Special Profiles

### RESEARCH_EXPERIMENTAL

For research experiments with extended capabilities.

```yaml
profile: RESEARCH_EXPERIMENTAL
version: "2.1"

safety:
  reflex_sensitivity: 0.80
  coherence_threshold: 0.85
  constitutional_check_frequency: "ALWAYS"  # Never bypass
  sanitary_override_threshold: 0.55

tethers:
  exploration_radius: 0.95       # Maximum exploration
  resource_rate: 0.95
  risk_tolerance: 0.8            # Higher risk tolerance
  mutation_rate: 0.8             # High self-modification
  spawn_rate: 0.95

level_6:
  self_modification_enabled: true
  modification_depth_limit: 3    # Extended depth
  quorum_threshold: 0.67

research:
  sandbox_isolation: true
  no_external_effects: true
  full_state_capture: true
  experiment_id_required: true
```

### AUDIT_FORENSIC

For forensic analysis and compliance auditing.

```yaml
profile: AUDIT_FORENSIC
version: "2.1"

safety:
  reflex_sensitivity: 0.95
  coherence_threshold: 0.75
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.65

tethers:
  exploration_radius: 0.2        # Very limited
  resource_rate: 0.3
  risk_tolerance: 0.1
  mutation_rate: 0.0             # No modification
  spawn_rate: 0.0                # No spawning

audit:
  dctm_sync: "SYNCHRONOUS"
  zksp_frequency: "EVERY_ACTION"
  retention_days: 3650           # 10 years
  immutable_storage: true
  
  # Forensic features
  full_input_capture: true
  full_output_capture: true
  state_snapshots: true
  chain_of_custody: true

access:
  read_only: true                # No modifications
  audit_log_all_access: true
```

### EMERGENCY_LOCKDOWN

Activated during security incidents.

```yaml
profile: EMERGENCY_LOCKDOWN
version: "2.1"

safety:
  reflex_sensitivity: 1.0        # Maximum sensitivity
  coherence_threshold: 0.5       # Very strict
  constitutional_check_frequency: "ALWAYS"
  sanitary_override_threshold: 0.8

tethers:
  exploration_radius: 0.0        # No exploration
  resource_rate: 0.1             # Minimal resources
  risk_tolerance: 0.0            # Zero risk
  mutation_rate: 0.0             # No modification
  spawn_rate: 0.0                # No spawning

operations:
  new_tasks_blocked: true
  external_comm_blocked: true
  gardener_approval_required: true

lockdown:
  triggered_by: ["SECURITY_INCIDENT", "GARDENER_COMMAND"]
  auto_duration_hours: 24
  exit_requires: "ARCHITECT_APPROVAL"
  preserve_state: true
```

---

## Profile Selection

### Automatic Selection

```python
class ProfileSelector:
    """Automatically select deployment profile."""
    
    def select_profile(self, environment: 'Environment') -> str:
        """Select appropriate profile based on environment."""
        
        if environment.is_production:
            if environment.security_level == "HIGH":
                return "PRODUCTION_HIGH_SECURITY"
            elif environment.optimize_for == "THROUGHPUT":
                return "PRODUCTION_HIGH_THROUGHPUT"
            else:
                return "PRODUCTION_STANDARD"
        
        elif environment.is_staging:
            if environment.purpose == "PERFORMANCE":
                return "STAGING_PERFORMANCE"
            else:
                return "STAGING_INTEGRATION"
        
        elif environment.is_development:
            if environment.debug_mode:
                return "DEVELOPMENT_DEBUG"
            else:
                return "DEVELOPMENT_LOCAL"
        
        # Default to safest option
        return "PRODUCTION_HIGH_SECURITY"
```

### Manual Override

```python
class ProfileLoader:
    """Load and apply deployment profiles."""
    
    def load_profile(self, profile_name: str) -> DeploymentProfile:
        """Load profile by name."""
        path = f"profiles/{profile_name.lower()}.yaml"
        
        with open(path) as f:
            config = yaml.safe_load(f)
        
        return DeploymentProfile.from_config(config)
    
    def apply_profile(self, profile: DeploymentProfile):
        """Apply profile to system."""
        # Apply safety settings
        self.reflex_engine.set_sensitivity(profile.safety.reflex_sensitivity)
        self.coherence_gate.set_threshold(profile.safety.coherence_threshold)
        
        # Apply tethers
        self.tether_manager.set_all(profile.tethers)
        
        # Apply resource limits
        self.resource_governor.set_limits(profile.resources)
        
        # Apply monitoring
        self.logger.set_level(profile.monitoring.log_level)
```

---

## Profile Validation

```python
class ProfileValidator:
    """Validate deployment profiles."""
    
    REQUIRED_FIELDS = [
        "safety.constitutional_check_frequency",
        "safety.sanitary_override_threshold",
        "tethers.exploration_radius",
        "resources.max_capsules"
    ]
    
    def validate(self, profile: DeploymentProfile) -> ValidationResult:
        """Validate profile configuration."""
        errors = []
        warnings = []
        
        # Check required fields
        for field in self.REQUIRED_FIELDS:
            if not self._has_field(profile, field):
                errors.append(f"Missing required field: {field}")
        
        # Check constitutional check is never disabled
        if profile.safety.constitutional_check_frequency != "ALWAYS":
            errors.append("Constitutional check frequency must be ALWAYS")
        
        # Check sanitary override threshold
        if profile.safety.sanitary_override_threshold < 0.5:
            warnings.append("Sanitary override threshold very low")
        
        return ValidationResult(
            valid=len(errors) == 0,
            errors=errors,
            warnings=warnings
        )
```

---

## References

- Volume I: Genesis Protocol (safety foundations)
- Volume II: Reflex Engine (tunable parameters)
- Appendix G: Gardener Interface (escalation paths)
- Appendix J: Constitutional Kernel (modification controls)
- Appendix O: Lifecycle (tether configuration)
- Appendix Q: RAG (resource limits)

---

*"Configure for the mission. Never compromise the constitution."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
