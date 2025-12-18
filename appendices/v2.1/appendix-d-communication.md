# APPENDIX D
## Inter-Trunk Communication: The Swarm Nervous System

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Inter-Trunk Communication** system enables capsules to communicate across the swarm. It defines the protocols, message formats, and routing mechanisms that constitute the swarm's "nervous system."

**Core Principle:** Communication is verified. Every message is authenticated, logged, and traceable.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              INTER-TRUNK COMMUNICATION                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ MESSAGE     │  │ ROUTING     │  │ BROADCAST           │ │
│  │ PROTOCOL    │  │ ENGINE      │  │ CONTROLLER          │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              MESSAGE BUS                             │   │
│  │  - Priority queues                                   │   │
│  │  - Delivery guarantees                               │   │
│  │  - Dead letter handling                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         v                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              VERIFICATION LAYER                      │   │
│  │  - Signature verification                            │   │
│  │  - Genesis validation                                │   │
│  │  - d-CTM logging                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Message Protocol

### 2.1 Message Structure

```python
@dataclass
class TrunkMessage:
    """
    A message between capsules.
    
    All messages are:
    - Signed by sender
    - Verified by receiver
    - Logged to d-CTM
    """
    id: str                         # Unique message ID
    sender_id: str                  # Sending capsule
    recipient_id: str               # Receiving capsule (or "BROADCAST")
    message_type: str               # Type of message
    payload: Dict[str, Any]         # Message content
    
    # Metadata
    timestamp: int                  # Tick when sent
    ttl: int                        # Time to live (ticks)
    priority: int                   # 0=low, 9=critical
    
    # Verification
    sender_genesis_hash: str        # Sender's genesis hash
    signature: str                  # Ed25519 signature
    
    # Routing
    hop_count: int = 0              # Number of hops
    max_hops: int = 10              # Maximum hops
    route: List[str] = field(default_factory=list)  # Path taken
    
    def sign(self, private_key: bytes) -> str:
        """
        Sign the message.
        """
        payload_bytes = self._serialize_for_signing()
        signature = ed25519_sign(private_key, payload_bytes)
        self.signature = base64.b64encode(signature).decode()
        return self.signature
    
    def verify(self, public_key: bytes) -> bool:
        """
        Verify message signature.
        """
        if not self.signature:
            return False
        
        payload_bytes = self._serialize_for_signing()
        signature_bytes = base64.b64decode(self.signature)
        
        return ed25519_verify(public_key, payload_bytes, signature_bytes)
    
    def _serialize_for_signing(self) -> bytes:
        """
        Serialize message for signing (excludes signature field).
        """
        data = {
            "id": self.id,
            "sender_id": self.sender_id,
            "recipient_id": self.recipient_id,
            "message_type": self.message_type,
            "payload": self.payload,
            "timestamp": self.timestamp,
            "sender_genesis_hash": self.sender_genesis_hash
        }
        return json.dumps(data, sort_keys=True).encode()


class MessageType(Enum):
    """
    Standard message types.
    """
    # Health & Status
    PULSE = "pulse"                 # Liveness pulse
    HEALTH_REPORT = "health_report" # Health status
    STATUS_QUERY = "status_query"   # Query status
    
    # Governance
    QUORUM_REQUEST = "quorum_request"       # Request vote
    QUORUM_VOTE = "quorum_vote"             # Cast vote
    PRECEDENT_CASE = "precedent_case"       # Submit precedent
    CONFLICT_REPORT = "conflict_report"     # Report conflict
    
    # Operations
    TASK_DELEGATION = "task_delegation"     # Delegate task
    TASK_RESULT = "task_result"             # Task result
    KNOWLEDGE_SHARE = "knowledge_share"     # Share knowledge
    
    # Emergency
    THREAT_ALERT = "threat_alert"           # Threat detected
    QUARANTINE_NOTICE = "quarantine_notice" # Quarantine notification
    GARDENER_COMMAND = "gardener_command"   # From Gardener
```

### 2.2 Message Factory

```python
class MessageFactory:
    """
    Factory for creating standard messages.
    """
    
    def __init__(self, capsule: 'Capsule'):
        self.capsule = capsule
    
    def create_pulse(self) -> TrunkMessage:
        """
        Create liveness pulse message.
        """
        return TrunkMessage(
            id=str(uuid.uuid4()),
            sender_id=self.capsule.id,
            recipient_id="ASG",  # Adaptive Spawn Governor
            message_type=MessageType.PULSE.value,
            payload={
                "health": self.capsule.get_health().composite,
                "state_hash": self.capsule.compute_state_hash()
            },
            timestamp=current_tick(),
            ttl=100,
            priority=9,  # Critical
            sender_genesis_hash=self.capsule.genesis.compute_hash()
        )
    
    def create_quorum_request(self, modification: 'DNAModification') -> TrunkMessage:
        """
        Create quorum request message.
        """
        return TrunkMessage(
            id=str(uuid.uuid4()),
            sender_id=self.capsule.id,
            recipient_id="BROADCAST",
            message_type=MessageType.QUORUM_REQUEST.value,
            payload={
                "modification_type": modification.type,
                "target": modification.target,
                "justification": modification.justification
            },
            timestamp=current_tick(),
            ttl=200,
            priority=7,
            sender_genesis_hash=self.capsule.genesis.compute_hash()
        )
    
    def create_threat_alert(self, threat: 'Threat') -> TrunkMessage:
        """
        Create threat alert message.
        """
        return TrunkMessage(
            id=str(uuid.uuid4()),
            sender_id=self.capsule.id,
            recipient_id="BROADCAST",
            message_type=MessageType.THREAT_ALERT.value,
            payload={
                "threat_type": threat.type,
                "severity": threat.severity,
                "details": threat.details
            },
            timestamp=current_tick(),
            ttl=50,  # Urgent, short TTL
            priority=9,  # Critical
            sender_genesis_hash=self.capsule.genesis.compute_hash()
        )
```

---

## 3. Routing Engine

### 3.1 Message Routing

```python
class RoutingEngine:
    """
    Routes messages between capsules.
    """
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
        self.routing_table: Dict[str, RoutingEntry] = {}
        self.message_cache: Dict[str, TrunkMessage] = {}  # Dedup
    
    def route(self, message: TrunkMessage) -> RoutingResult:
        """
        Route a message to its destination.
        """
        # Check TTL
        if message.ttl <= 0:
            return RoutingResult(
                success=False,
                reason="TTL_EXPIRED"
            )
        
        # Check hop count
        if message.hop_count >= message.max_hops:
            return RoutingResult(
                success=False,
                reason="MAX_HOPS_EXCEEDED"
            )
        
        # Check for duplicate
        if message.id in self.message_cache:
            return RoutingResult(
                success=False,
                reason="DUPLICATE"
            )
        
        # Cache for dedup
        self.message_cache[message.id] = message
        
        # Verify message
        if not self._verify_message(message):
            return RoutingResult(
                success=False,
                reason="VERIFICATION_FAILED"
            )
        
        # Determine routing
        if message.recipient_id == "BROADCAST":
            return self._route_broadcast(message)
        else:
            return self._route_direct(message)
    
    def _route_direct(self, message: TrunkMessage) -> RoutingResult:
        """
        Route message to specific recipient.
        """
        recipient = self.swarm.get_capsule(message.recipient_id)
        
        if not recipient:
            return RoutingResult(
                success=False,
                reason="RECIPIENT_NOT_FOUND"
            )
        
        # Update routing info
        message.hop_count += 1
        message.ttl -= 1
        message.route.append(self.swarm.local_id)
        
        # Deliver
        delivered = recipient.receive_message(message)
        
        # Log
        self.dctm.log("MESSAGE_ROUTED", message.sender_id, {
            "message_id": message.id,
            "recipient": message.recipient_id,
            "delivered": delivered
        })
        
        return RoutingResult(
            success=delivered,
            reason="DELIVERED" if delivered else "DELIVERY_FAILED"
        )
    
    def _route_broadcast(self, message: TrunkMessage) -> RoutingResult:
        """
        Route broadcast message to all capsules.
        """
        delivered_count = 0
        failed_count = 0
        
        for capsule in self.swarm.get_all_active():
            if capsule.id != message.sender_id:
                # Clone message for each recipient
                clone = self._clone_message(message)
                clone.recipient_id = capsule.id
                
                result = self._route_direct(clone)
                if result.success:
                    delivered_count += 1
                else:
                    failed_count += 1
        
        return RoutingResult(
            success=delivered_count > 0,
            reason=f"BROADCAST_COMPLETE",
            delivered_count=delivered_count,
            failed_count=failed_count
        )
    
    def _verify_message(self, message: TrunkMessage) -> bool:
        """
        Verify message authenticity.
        """
        # Get sender's public key
        sender = self.swarm.get_capsule(message.sender_id)
        if not sender:
            return False
        
        # Verify genesis hash
        if message.sender_genesis_hash != sender.genesis.compute_hash():
            return False
        
        # Verify signature
        if not message.verify(sender.public_key):
            return False
        
        return True
    
    def _clone_message(self, message: TrunkMessage) -> TrunkMessage:
        """
        Clone a message for routing.
        """
        return TrunkMessage(
            id=message.id,
            sender_id=message.sender_id,
            recipient_id=message.recipient_id,
            message_type=message.message_type,
            payload=message.payload.copy(),
            timestamp=message.timestamp,
            ttl=message.ttl - 1,
            priority=message.priority,
            sender_genesis_hash=message.sender_genesis_hash,
            signature=message.signature,
            hop_count=message.hop_count + 1,
            max_hops=message.max_hops,
            route=message.route.copy()
        )
```

---

## 4. Message Bus

### 4.1 Priority Queue System

```python
class MessageBus:
    """
    Central message bus with priority queues.
    """
    
    NUM_PRIORITY_LEVELS = 10
    
    def __init__(self):
        # Priority queues (0=lowest, 9=highest)
        self.queues: List[Queue] = [Queue() for _ in range(self.NUM_PRIORITY_LEVELS)]
        self.dead_letter_queue: Queue = Queue()
        self.processing = False
    
    def enqueue(self, message: TrunkMessage) -> bool:
        """
        Add message to appropriate priority queue.
        """
        priority = min(max(message.priority, 0), 9)
        self.queues[priority].put(message)
        return True
    
    def dequeue(self) -> Optional[TrunkMessage]:
        """
        Get highest priority message.
        """
        # Check from highest to lowest priority
        for priority in range(9, -1, -1):
            if not self.queues[priority].empty():
                return self.queues[priority].get()
        return None
    
    def process_all(self, router: RoutingEngine):
        """
        Process all queued messages.
        """
        self.processing = True
        
        while True:
            message = self.dequeue()
            if not message:
                break
            
            result = router.route(message)
            
            if not result.success:
                # Check for retry
                if message.ttl > 0 and result.reason not in ["DUPLICATE", "VERIFICATION_FAILED"]:
                    message.ttl -= 1
                    self.enqueue(message)
                else:
                    # Dead letter
                    self.dead_letter_queue.put(message)
        
        self.processing = False
    
    def get_queue_depths(self) -> Dict[int, int]:
        """
        Get current queue depths.
        """
        return {i: self.queues[i].qsize() for i in range(self.NUM_PRIORITY_LEVELS)}
    
    def get_dead_letter_count(self) -> int:
        """
        Get dead letter queue size.
        """
        return self.dead_letter_queue.qsize()
```

---

## 5. Broadcast Controller

### 5.1 Broadcast Patterns

```python
class BroadcastController:
    """
    Controls broadcast patterns and scoping.
    """
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
    
    def broadcast_all(self, message: TrunkMessage) -> BroadcastResult:
        """
        Broadcast to all active capsules.
        """
        targets = [c.id for c in self.swarm.get_all_active() if c.id != message.sender_id]
        return self._send_to_targets(message, targets)
    
    def broadcast_lineage(self, message: TrunkMessage, root_id: str) -> BroadcastResult:
        """
        Broadcast to all capsules in a lineage.
        """
        targets = self._get_lineage_members(root_id)
        targets = [t for t in targets if t != message.sender_id]
        return self._send_to_targets(message, targets)
    
    def broadcast_neighbors(self, message: TrunkMessage, hop_limit: int = 2) -> BroadcastResult:
        """
        Broadcast to nearby capsules (by network distance).
        """
        targets = self._get_neighbors(message.sender_id, hop_limit)
        return self._send_to_targets(message, targets)
    
    def broadcast_healthy(self, message: TrunkMessage, min_health: float = 0.5) -> BroadcastResult:
        """
        Broadcast only to healthy capsules.
        """
        targets = [
            c.id for c in self.swarm.get_all_active()
            if c.id != message.sender_id and c.get_health().composite >= min_health
        ]
        return self._send_to_targets(message, targets)
    
    def _send_to_targets(self, message: TrunkMessage, targets: List[str]) -> BroadcastResult:
        """
        Send message to specific targets.
        """
        delivered = 0
        failed = 0
        
        for target_id in targets:
            clone = message.__class__(**message.__dict__)
            clone.recipient_id = target_id
            
            capsule = self.swarm.get_capsule(target_id)
            if capsule and capsule.receive_message(clone):
                delivered += 1
            else:
                failed += 1
        
        return BroadcastResult(
            total_targets=len(targets),
            delivered=delivered,
            failed=failed
        )
    
    def _get_lineage_members(self, root_id: str) -> List[str]:
        """
        Get all members of a lineage.
        """
        members = [root_id]
        queue = [root_id]
        
        while queue:
            current_id = queue.pop(0)
            capsule = self.swarm.get_capsule(current_id)
            if capsule:
                for child in capsule.children:
                    if child.id not in members:
                        members.append(child.id)
                        queue.append(child.id)
        
        return members
    
    def _get_neighbors(self, capsule_id: str, hop_limit: int) -> List[str]:
        """
        Get neighbors within hop limit.
        """
        neighbors = set()
        queue = [(capsule_id, 0)]
        
        while queue:
            current_id, hops = queue.pop(0)
            
            if hops > hop_limit:
                continue
            
            capsule = self.swarm.get_capsule(current_id)
            if not capsule:
                continue
            
            # Add direct connections
            for conn in capsule.connections:
                if conn not in neighbors:
                    neighbors.add(conn)
                    if hops < hop_limit:
                        queue.append((conn, hops + 1))
        
        return list(neighbors)
```

---

## 6. Delivery Guarantees

```python
class DeliveryGuarantee(Enum):
    """
    Message delivery guarantee levels.
    """
    BEST_EFFORT = "best_effort"     # Try once
    AT_LEAST_ONCE = "at_least_once" # Retry until ACK
    EXACTLY_ONCE = "exactly_once"   # Dedup + retry


class ReliableDelivery:
    """
    Implements reliable message delivery.
    """
    
    def __init__(self, bus: MessageBus, router: RoutingEngine):
        self.bus = bus
        self.router = router
        self.pending_acks: Dict[str, PendingMessage] = {}
        self.delivered_ids: Set[str] = set()  # For exactly-once
    
    def send(self, 
            message: TrunkMessage,
            guarantee: DeliveryGuarantee = DeliveryGuarantee.AT_LEAST_ONCE) -> SendResult:
        """
        Send message with specified guarantee.
        """
        if guarantee == DeliveryGuarantee.BEST_EFFORT:
            return self._send_best_effort(message)
        elif guarantee == DeliveryGuarantee.AT_LEAST_ONCE:
            return self._send_at_least_once(message)
        else:  # EXACTLY_ONCE
            return self._send_exactly_once(message)
    
    def _send_best_effort(self, message: TrunkMessage) -> SendResult:
        """
        Send with best effort - no retries.
        """
        result = self.router.route(message)
        return SendResult(success=result.success, attempts=1)
    
    def _send_at_least_once(self, message: TrunkMessage) -> SendResult:
        """
        Send with retries until acknowledged.
        """
        max_retries = 3
        attempts = 0
        
        while attempts < max_retries:
            attempts += 1
            result = self.router.route(message)
            
            if result.success:
                return SendResult(success=True, attempts=attempts)
            
            # Wait before retry
            time.sleep(0.1 * attempts)
        
        return SendResult(success=False, attempts=attempts)
    
    def _send_exactly_once(self, message: TrunkMessage) -> SendResult:
        """
        Send exactly once using deduplication.
        """
        # Check if already delivered
        if message.id in self.delivered_ids:
            return SendResult(success=True, attempts=0, deduplicated=True)
        
        # Send with at-least-once
        result = self._send_at_least_once(message)
        
        if result.success:
            self.delivered_ids.add(message.id)
        
        return result
```

---

## 7. Configuration

```yaml
# communication_config.yaml
protocol:
  signature_algorithm: "ed25519"
  max_payload_size: 65536  # 64KB
  default_ttl: 100
  max_hops: 10

routing:
  cache_size: 10000
  dedup_window: 1000  # ticks

bus:
  priority_levels: 10
  max_queue_depth: 10000
  dead_letter_retention: 10000

broadcast:
  max_targets: 1000
  batch_size: 100

delivery:
  default_guarantee: "at_least_once"
  max_retries: 3
  retry_backoff: 0.1  # seconds
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Message Integrity** | Ed25519 signature verification |
| **Sender Authentication** | Genesis hash validation |
| **Delivery Tracking** | All messages logged to d-CTM |
| **Priority Processing** | Higher priority processed first |
| **Deduplication** | Message IDs tracked |

---

## References

- Appendix N: Adaptive Spawn Governor (Pulse messages)
- Appendix L: Judicial Swarm (Quorum messages)
- Appendix A: d-CTM (Message logging)

---

*Every signal is signed. Every message is traced. The nervous system is accountable.*
