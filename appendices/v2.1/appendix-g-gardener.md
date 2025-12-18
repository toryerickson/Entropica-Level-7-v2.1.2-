# APPENDIX G
## Gardener Interface: Human Authority

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Gardener Interface** is the human authority layer—the mechanism by which humans maintain ultimate oversight and control over the EFM system. The Gardener is not a user; the Gardener is the constitutional authority.

**Core Principle:** Human authority is absolute. The system serves human needs by design, not by choice.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   GARDENER INTERFACE                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              HUMAN AUTHORITY                        │   │
│  │  - Emergency Override                               │   │
│  │  - System Halt                                      │   │
│  │  - Capsule Termination                              │   │
│  │  - Policy Adjustment                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         v                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ COMMAND     │  │ MONITORING  │  │ ALERT               │ │
│  │ INTERFACE   │  │ DASHBOARD   │  │ SYSTEM              │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              AUTHENTICATION LAYER                    │   │
│  │  - HSM-backed credentials                           │   │
│  │  - Multi-factor verification                        │   │
│  │  - Action confirmation                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Gardener Commands

### 2.1 Command Hierarchy

```python
class GardenerCommand(Enum):
    """
    Commands available to the Gardener.
    
    Ordered by severity.
    """
    # Level 1: Monitoring (no system impact)
    VIEW_STATUS = "view_status"
    VIEW_HEALTH = "view_health"
    VIEW_LOGS = "view_logs"
    QUERY_CAPSULE = "query_capsule"
    
    # Level 2: Advisory (soft interventions)
    SEND_ADVISORY = "send_advisory"
    ADJUST_PRIORITY = "adjust_priority"
    SCHEDULE_MAINTENANCE = "schedule_maintenance"
    
    # Level 3: Intervention (direct action)
    QUARANTINE_CAPSULE = "quarantine_capsule"
    TERMINATE_CAPSULE = "terminate_capsule"
    PAUSE_SPAWNING = "pause_spawning"
    ADJUST_TETHERS = "adjust_tethers"
    
    # Level 4: Emergency (system-wide)
    EMERGENCY_HALT = "emergency_halt"
    FORCE_CONSERVATION = "force_conservation"
    MASS_QUARANTINE = "mass_quarantine"
    
    # Level 5: Constitutional (highest authority)
    SYSTEM_SHUTDOWN = "system_shutdown"
    FULL_RESET = "full_reset"


class GardenerInterface:
    """
    The human authority interface.
    
    Gardener commands execute within 100ms.
    """
    
    def __init__(self, vault: 'Vault', auth: 'AuthenticationSystem'):
        self.vault = vault
        self.auth = auth
        self.command_log: List[GardenerAction] = []
    
    def execute_command(self, 
                       command: GardenerCommand,
                       params: Dict[str, Any],
                       credentials: 'GardenerCredentials') -> CommandResult:
        """
        Execute a Gardener command.
        
        All commands are:
        1. Authenticated
        2. Logged to d-CTM
        3. Executed within 100ms
        """
        start_time = time.perf_counter()
        
        # Authenticate
        if not self.auth.verify_gardener(credentials):
            return CommandResult(
                success=False,
                reason="AUTHENTICATION_FAILED"
            )
        
        # Check authorization level
        if not self._is_authorized(credentials, command):
            return CommandResult(
                success=False,
                reason="INSUFFICIENT_AUTHORIZATION"
            )
        
        # Confirm high-severity commands
        if self._requires_confirmation(command):
            if not params.get("confirmed", False):
                return CommandResult(
                    success=False,
                    reason="CONFIRMATION_REQUIRED",
                    requires_confirmation=True
                )
        
        # Execute
        result = self._execute(command, params)
        
        # Log
        elapsed_ms = (time.perf_counter() - start_time) * 1000
        self._log_action(command, params, result, elapsed_ms)
        
        return result
    
    def _execute(self, command: GardenerCommand, params: Dict) -> CommandResult:
        """
        Execute the actual command.
        """
        handlers = {
            GardenerCommand.VIEW_STATUS: self._handle_view_status,
            GardenerCommand.VIEW_HEALTH: self._handle_view_health,
            GardenerCommand.QUARANTINE_CAPSULE: self._handle_quarantine,
            GardenerCommand.TERMINATE_CAPSULE: self._handle_terminate,
            GardenerCommand.EMERGENCY_HALT: self._handle_emergency_halt,
            GardenerCommand.SYSTEM_SHUTDOWN: self._handle_shutdown,
            # ... other handlers
        }
        
        if command in handlers:
            return handlers[command](params)
        
        return CommandResult(success=False, reason="UNKNOWN_COMMAND")
```

### 2.2 Emergency Override

```python
class EmergencyOverride:
    """
    Emergency override capability.
    
    The Gardener can override ANY system decision.
    Executes within 100ms.
    """
    
    def override(self,
                target: str,
                action: str,
                credentials: 'GardenerCredentials') -> OverrideResult:
        """
        Execute emergency override.
        
        This bypasses normal processing and executes immediately.
        """
        # Authenticate
        if not self.auth.verify_emergency_credentials(credentials):
            return OverrideResult(success=False, reason="INVALID_CREDENTIALS")
        
        # Log intent BEFORE action
        self.dctm.log("GARDENER_OVERRIDE_INTENT", "GARDENER", {
            "target": target,
            "action": action,
            "timestamp": current_tick()
        })
        
        # Execute override
        result = self._execute_override(target, action)
        
        # Log result
        self.dctm.log("GARDENER_OVERRIDE_EXECUTED", "GARDENER", {
            "target": target,
            "action": action,
            "result": result.success,
            "reason": result.reason
        })
        
        return result
    
    def _execute_override(self, target: str, action: str) -> OverrideResult:
        """
        Execute the override action.
        """
        if action == "HALT":
            return self._halt_target(target)
        elif action == "TERMINATE":
            return self._terminate_target(target)
        elif action == "QUARANTINE":
            return self._quarantine_target(target)
        elif action == "RELEASE":
            return self._release_target(target)
        elif action == "FORCE_TREATMENT":
            return self._force_treatment(target)
        else:
            return OverrideResult(success=False, reason="UNKNOWN_ACTION")
```

---

## 3. Monitoring Dashboard

### 3.1 Real-Time Views

```python
class GardenerDashboard:
    """
    Real-time monitoring dashboard for Gardener.
    """
    
    def get_system_status(self) -> SystemStatus:
        """
        Get comprehensive system status.
        """
        return SystemStatus(
            # Health metrics
            system_health=self.health_aggregator.get_system_health(),
            
            # Capsule counts
            total_capsules=self.registry.count_total(),
            active_capsules=self.registry.count_active(),
            quarantined_capsules=self.quarantine.count_quarantined(),
            
            # Resource status
            cpu_utilization=self.rag.get_cpu_utilization(),
            memory_utilization=self.rag.get_memory_utilization(),
            stress_level=self.rag.get_stress_level(),
            
            # Coherence
            swarm_coherence_index=self.swarm.get_sci(),
            
            # Anomalies
            active_anomalies=self.anomaly_tracker.count_active(),
            critical_alerts=self.alert_system.count_critical(),
            
            # Timestamps
            last_update=current_tick(),
            uptime_ticks=self.system.get_uptime()
        )
    
    def get_capsule_tree(self) -> CapsuleTree:
        """
        Get hierarchical view of all capsules.
        """
        root_capsules = self.registry.get_root_capsules()
        
        return CapsuleTree(
            roots=[self._build_tree_node(c) for c in root_capsules]
        )
    
    def _build_tree_node(self, capsule: 'Capsule') -> TreeNode:
        """
        Build tree node for capsule and descendants.
        """
        return TreeNode(
            capsule_id=capsule.id,
            health=capsule.get_health().composite,
            status=capsule.status,
            children=[self._build_tree_node(c) for c in capsule.children]
        )
    
    def get_health_heatmap(self) -> HealthHeatmap:
        """
        Get health heatmap for all capsules.
        """
        capsules = self.registry.get_all_active()
        
        return HealthHeatmap(
            cells=[
                HeatmapCell(
                    capsule_id=c.id,
                    health=c.get_health().composite,
                    status=c.status,
                    position=self._get_swarm_position(c)
                )
                for c in capsules
            ]
        )
```

### 3.2 Alert System

```python
class GardenerAlertSystem:
    """
    Alert system for Gardener notification.
    """
    
    class AlertLevel(Enum):
        INFO = "info"
        WARNING = "warning"
        CRITICAL = "critical"
        EMERGENCY = "emergency"
    
    def __init__(self):
        self.active_alerts: List[Alert] = []
        self.alert_handlers: Dict[str, Callable] = {}
    
    def raise_alert(self, 
                   level: AlertLevel,
                   category: str,
                   message: str,
                   details: Dict[str, Any]) -> Alert:
        """
        Raise alert to Gardener.
        """
        alert = Alert(
            id=str(uuid.uuid4()),
            level=level,
            category=category,
            message=message,
            details=details,
            timestamp=current_tick(),
            acknowledged=False
        )
        
        self.active_alerts.append(alert)
        
        # Log to d-CTM
        self.dctm.log("GARDENER_ALERT", "SYSTEM", {
            "alert_id": alert.id,
            "level": level.value,
            "category": category,
            "message": message
        })
        
        # Notify through configured channels
        self._notify_gardener(alert)
        
        return alert
    
    def emergency_alert(self, category: str, details: Dict[str, Any]):
        """
        Raise emergency alert.
        
        These require immediate Gardener attention.
        """
        return self.raise_alert(
            level=self.AlertLevel.EMERGENCY,
            category=category,
            message=f"EMERGENCY: {category}",
            details=details
        )
    
    def acknowledge_alert(self, alert_id: str, gardener_id: str):
        """
        Acknowledge an alert.
        """
        for alert in self.active_alerts:
            if alert.id == alert_id:
                alert.acknowledged = True
                alert.acknowledged_by = gardener_id
                alert.acknowledged_at = current_tick()
                
                self.dctm.log("ALERT_ACKNOWLEDGED", gardener_id, {
                    "alert_id": alert_id
                })
                
                return True
        
        return False
```

---

## 4. Authentication & Authorization

### 4.1 Credential System

```python
class GardenerCredentials:
    """
    Gardener authentication credentials.
    
    HSM-backed for security.
    """
    
    def __init__(self, gardener_id: str, hsm_token: str, mfa_code: str):
        self.gardener_id = gardener_id
        self.hsm_token = hsm_token
        self.mfa_code = mfa_code
        self.timestamp = time.time()
    
    def is_expired(self) -> bool:
        """
        Check if credentials have expired.
        
        Credentials valid for 15 minutes.
        """
        return (time.time() - self.timestamp) > 900  # 15 minutes


class GardenerAuthenticationSystem:
    """
    Authentication system for Gardener access.
    """
    
    def __init__(self, hsm: 'HSM'):
        self.hsm = hsm
        self.authorized_gardeners: Dict[str, GardenerProfile] = {}
        self.session_tokens: Dict[str, Session] = {}
    
    def verify_gardener(self, credentials: GardenerCredentials) -> bool:
        """
        Verify Gardener credentials.
        """
        # Check expiration
        if credentials.is_expired():
            return False
        
        # Verify HSM token
        if not self.hsm.verify_token(credentials.hsm_token):
            return False
        
        # Verify MFA
        if not self._verify_mfa(credentials.gardener_id, credentials.mfa_code):
            return False
        
        # Check authorization
        if credentials.gardener_id not in self.authorized_gardeners:
            return False
        
        return True
    
    def verify_emergency_credentials(self, credentials: GardenerCredentials) -> bool:
        """
        Verify credentials for emergency actions.
        
        Requires additional verification.
        """
        if not self.verify_gardener(credentials):
            return False
        
        # Check emergency authorization
        profile = self.authorized_gardeners[credentials.gardener_id]
        if not profile.emergency_authorized:
            return False
        
        return True
```

### 4.2 Authorization Levels

```python
class GardenerProfile:
    """
    Gardener authorization profile.
    """
    
    class AuthLevel(Enum):
        OBSERVER = 1       # View only
        OPERATOR = 2       # Advisory + some interventions
        ADMINISTRATOR = 3  # Full intervention
        EMERGENCY = 4      # Emergency powers
        ROOT = 5           # Full constitutional authority
    
    def __init__(self, gardener_id: str, auth_level: AuthLevel):
        self.gardener_id = gardener_id
        self.auth_level = auth_level
        self.emergency_authorized = auth_level >= self.AuthLevel.EMERGENCY
        self.constitutional_authority = auth_level == self.AuthLevel.ROOT
    
    def can_execute(self, command: GardenerCommand) -> bool:
        """
        Check if Gardener can execute command.
        """
        command_levels = {
            # Level 1: Monitoring
            GardenerCommand.VIEW_STATUS: self.AuthLevel.OBSERVER,
            GardenerCommand.VIEW_HEALTH: self.AuthLevel.OBSERVER,
            
            # Level 2: Advisory
            GardenerCommand.SEND_ADVISORY: self.AuthLevel.OPERATOR,
            GardenerCommand.ADJUST_PRIORITY: self.AuthLevel.OPERATOR,
            
            # Level 3: Intervention
            GardenerCommand.QUARANTINE_CAPSULE: self.AuthLevel.ADMINISTRATOR,
            GardenerCommand.TERMINATE_CAPSULE: self.AuthLevel.ADMINISTRATOR,
            
            # Level 4: Emergency
            GardenerCommand.EMERGENCY_HALT: self.AuthLevel.EMERGENCY,
            GardenerCommand.MASS_QUARANTINE: self.AuthLevel.EMERGENCY,
            
            # Level 5: Constitutional
            GardenerCommand.SYSTEM_SHUTDOWN: self.AuthLevel.ROOT,
            GardenerCommand.FULL_RESET: self.AuthLevel.ROOT,
        }
        
        required_level = command_levels.get(command, self.AuthLevel.ROOT)
        return self.auth_level.value >= required_level.value
```

---

## 5. Sanitary Override

```python
class SanitaryOverride:
    """
    Sanitary Override capability.
    
    If a capsule's Health Score < 0.6, it loses its Right to Consent.
    It is treated or terminated.
    """
    
    SANITARY_THRESHOLD = 0.6
    
    def evaluate_for_sanitary_override(self, capsule: 'Capsule') -> SanitaryDecision:
        """
        Evaluate if capsule requires sanitary override.
        """
        health = capsule.get_health().composite
        
        if health >= self.SANITARY_THRESHOLD:
            return SanitaryDecision(
                override_required=False,
                reason="HEALTH_ADEQUATE"
            )
        
        # Health below threshold - capsule loses consent rights
        return SanitaryDecision(
            override_required=True,
            reason="HEALTH_CRITICAL",
            health_score=health,
            recommended_action=self._determine_action(health)
        )
    
    def _determine_action(self, health: float) -> str:
        """
        Determine appropriate action based on health.
        """
        if health < 0.2:
            return "TERMINATE_AND_PRESERVE"
        elif health < 0.4:
            return "QUARANTINE_AND_TREAT"
        else:
            return "MANDATORY_TREATMENT"
    
    def execute_sanitary_override(self, 
                                 capsule: 'Capsule',
                                 decision: SanitaryDecision) -> OverrideResult:
        """
        Execute sanitary override.
        
        No consent required - this is medical emergency.
        """
        # Log intent
        self.dctm.log("SANITARY_OVERRIDE", capsule.id, {
            "health": decision.health_score,
            "action": decision.recommended_action
        })
        
        # Execute action
        if decision.recommended_action == "TERMINATE_AND_PRESERVE":
            # Preserve knowledge first
            self.medical.preserve_knowledge(capsule)
            self.quarantine.terminate(capsule.id, "SANITARY_OVERRIDE")
            
        elif decision.recommended_action == "QUARANTINE_AND_TREAT":
            self.quarantine.quarantine_immediate(capsule.id, "SANITARY_OVERRIDE")
            self.medical.schedule_emergency_treatment(capsule.id)
            
        else:  # MANDATORY_TREATMENT
            self.medical.schedule_mandatory_treatment(capsule.id)
        
        return OverrideResult(success=True, action=decision.recommended_action)
```

---

## 6. Performance Guarantees

| Operation | Guarantee |
|-----------|-----------|
| **Command Execution** | <100ms |
| **Emergency Override** | <100ms |
| **Status Query** | <50ms |
| **Alert Delivery** | <10ms |
| **Authentication** | <20ms |

---

## 7. Configuration

```yaml
# gardener_config.yaml
authentication:
  hsm_enabled: true
  mfa_required: true
  session_timeout_minutes: 15
  max_failed_attempts: 3

authorization:
  levels:
    observer: 1
    operator: 2
    administrator: 3
    emergency: 4
    root: 5

commands:
  high_severity_confirmation: true
  emergency_cooldown_seconds: 60

alerts:
  emergency_channels: ["sms", "email", "pager"]
  critical_channels: ["email", "slack"]
  
sanitary:
  threshold: 0.6
  auto_execute: false  # Require Gardener approval by default
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Human Authority** | Gardener override always executes |
| **Response Time** | All commands complete within 100ms |
| **Audit Trail** | All actions logged to d-CTM |
| **Authentication** | HSM-backed multi-factor |
| **Failsafe** | Emergency halt always available |

---

## References

- Volume I: Layer 0 Foundation
- Volume III §18: Human Necessity
- Appendix N: Adaptive Spawn Governor

---

*The Gardener is not optional. Human authority is constitutional.*
