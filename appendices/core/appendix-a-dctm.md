# APPENDIX A
## d-CTM: Distributed Capsule Trace Manifest

**Version 2.0**  
**EFM Codex**

---

## Overview

The **d-CTM (Distributed Capsule Trace Manifest)** is the immutable forensic audit chain that records every action in the EFM system. It provides complete transparency and accountability—any action can be traced back to its origin.

**Core Guarantee:** If it happened, it's in the d-CTM. If it's not in the d-CTM, it didn't happen.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      d-CTM CHAIN                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐    │
│  │ GENESIS │ → │ ENTRY 1 │ → │ ENTRY 2 │ → │ ENTRY N │    │
│  │  BLOCK  │   │         │   │         │   │         │    │
│  └─────────┘   └─────────┘   └─────────┘   └─────────┘    │
│       │             │             │             │          │
│       v             v             v             v          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  HASH CHAIN                          │   │
│  │  H(G) → H(G,E1) → H(G,E1,E2) → ... → H(G,...,En)   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Entry Structure

```python
@dataclass
class DCTMEntry:
    """A single entry in the d-CTM chain."""
    
    # Identity
    entry_id: str              # UUID
    sequence_number: int       # Monotonic counter
    
    # Chain linkage
    previous_hash: str         # Hash of previous entry
    
    # Event data
    event_type: str            # Event category
    event_timestamp: float     # Unix timestamp
    capsule_id: str            # Source capsule
    payload: Dict[str, Any]    # Event-specific data
    
    # Integrity
    entry_hash: str            # Hash of this entry
    signature: str             # Cryptographic signature
```

---

## 3. Event Types

### 3.1 Lifecycle Events

| Event | Description |
|-------|-------------|
| `CAPSULE_GENESIS` | New capsule created |
| `CAPSULE_SPAWN` | Child capsule spawned |
| `CAPSULE_TERMINATE` | Capsule terminated |
| `CAPSULE_TREATMENT` | Capsule entered medical |

### 3.2 Processing Events

| Event | Description |
|-------|-------------|
| `INPUT_RECEIVED` | User input received |
| `REFLEX_MATCH` | Reflex pattern matched |
| `ARBITER_DECISION` | Arbiter made decision |
| `OUTPUT_GENERATED` | Response generated |

### 3.3 Health Events

| Event | Description |
|-------|-------------|
| `HEALTH_CHECK` | Routine health assessment |
| `HEALTH_WARNING` | Health below threshold |
| `HEALTH_CRITICAL` | Critical health state |
| `HEALTH_RECOVERY` | Health restored |

### 3.4 Governance Events

| Event | Description |
|-------|-------------|
| `GARDENER_OVERRIDE` | Human override executed |
| `CONSTITUTIONAL_CHECK` | C1-C5 evaluation |
| `SPAWN_DENIED` | Spawn condition failed |
| `PRECEDENT_ADDED` | New precedent recorded |

---

## 4. Hash Chain Integrity

### 4.1 Entry Hash Computation

```python
def compute_entry_hash(entry: DCTMEntry) -> str:
    """Compute hash for a d-CTM entry."""
    data = json.dumps({
        'entry_id': entry.entry_id,
        'sequence': entry.sequence_number,
        'prev': entry.previous_hash,
        'type': entry.event_type,
        'time': entry.event_timestamp,
        'capsule': entry.capsule_id,
        'payload': entry.payload
    }, sort_keys=True)
    
    return hashlib.sha256(data.encode()).hexdigest()
```

### 4.2 Chain Verification

```python
def verify_chain(entries: List[DCTMEntry]) -> Tuple[bool, Optional[str]]:
    """Verify integrity of entire chain."""
    if not entries:
        return True, None
    
    for i, entry in enumerate(entries):
        # Verify hash computation
        computed = compute_entry_hash(entry)
        if computed != entry.entry_hash:
            return False, f"Hash mismatch at entry {i}"
        
        # Verify chain linkage
        if i > 0:
            if entry.previous_hash != entries[i-1].entry_hash:
                return False, f"Chain break at entry {i}"
    
    return True, None
```

---

## 5. Distributed Replication

### 5.1 Replication Protocol

```
┌─────────────────────────────────────────────────────────────┐
│                 REPLICATION PROTOCOL                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PRIMARY NODE                                              │
│       │                                                    │
│       │ New Entry                                          │
│       v                                                    │
│  ┌─────────────┐                                          │
│  │ BROADCAST   │ ──────────────────────────────────────┐  │
│  └─────────────┘                                        │  │
│       │                                                 │  │
│       v                                                 v  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │ REPLICA 1   │  │ REPLICA 2   │  │ REPLICA N   │       │
│  └─────────────┘  └─────────────┘  └─────────────┘       │
│       │                │                │                 │
│       v                v                v                 │
│  ┌─────────────────────────────────────────────────┐     │
│  │              CONSENSUS (2f+1 of 3f+1)           │     │
│  └─────────────────────────────────────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Consistency Guarantees

| Property | Guarantee |
|----------|-----------|
| Durability | Entry persists after acknowledgment |
| Ordering | Global total order across all nodes |
| Integrity | Tampering detected within 1 round |
| Availability | Survives f failures in 3f+1 nodes |

---

## 6. Query Interface

### 6.1 Query Methods

```python
class DCTM:
    def log(self, event_type: str, capsule_id: str, 
            payload: Dict[str, Any]) -> DCTMEntry:
        """Log a new event."""
        pass
    
    def query_by_capsule(self, capsule_id: str) -> List[DCTMEntry]:
        """Get all entries for a capsule."""
        pass
    
    def query_by_type(self, event_type: str) -> List[DCTMEntry]:
        """Get all entries of a type."""
        pass
    
    def query_by_time_range(self, start: float, 
                            end: float) -> List[DCTMEntry]:
        """Get entries in time range."""
        pass
    
    def query_by_lineage(self, capsule_id: str) -> List[DCTMEntry]:
        """Get entries for capsule and all ancestors."""
        pass
    
    def verify_chain(self) -> Tuple[bool, Optional[str]]:
        """Verify entire chain integrity."""
        pass
```

### 6.2 Indexed Fields

| Field | Index Type | Query Performance |
|-------|------------|-------------------|
| `entry_id` | Hash | O(1) |
| `capsule_id` | B-tree | O(log n) |
| `event_type` | B-tree | O(log n) |
| `timestamp` | B-tree | O(log n) |
| `sequence` | Sequential | O(1) for latest |

---

## 7. Forensic Analysis

### 7.1 Reconstruction

```python
def reconstruct_capsule_history(capsule_id: str) -> CapsuleHistory:
    """Reconstruct complete history of a capsule."""
    entries = dctm.query_by_capsule(capsule_id)
    
    history = CapsuleHistory(capsule_id)
    
    for entry in entries:
        if entry.event_type == 'CAPSULE_GENESIS':
            history.set_genesis(entry)
        elif entry.event_type == 'INPUT_RECEIVED':
            history.add_input(entry)
        elif entry.event_type == 'OUTPUT_GENERATED':
            history.add_output(entry)
        elif entry.event_type == 'HEALTH_CHECK':
            history.add_health_point(entry)
        # ... etc
    
    return history
```

### 7.2 Anomaly Investigation

```python
def investigate_anomaly(capsule_id: str, 
                       anomaly_time: float) -> Investigation:
    """Investigate an anomaly by examining d-CTM history."""
    
    # Get entries around anomaly time
    window_start = anomaly_time - 1000  # ticks before
    window_end = anomaly_time + 100     # ticks after
    
    entries = dctm.query_by_capsule_and_time(
        capsule_id, window_start, window_end
    )
    
    # Analyze patterns
    investigation = Investigation()
    investigation.timeline = build_timeline(entries)
    investigation.health_trajectory = extract_health_trajectory(entries)
    investigation.input_patterns = analyze_inputs(entries)
    investigation.behavioral_changes = detect_changes(entries)
    
    return investigation
```

---

## 8. Performance

| Operation | Latency | Throughput |
|-----------|---------|------------|
| Log entry | <5ms | 10,000/sec |
| Query by ID | <1ms | 50,000/sec |
| Query by capsule | <10ms | 5,000/sec |
| Verify chain (1M entries) | <30s | N/A |

---

## 9. Configuration

```yaml
# dctm_config.yaml
storage:
  backend: rocksdb
  path: /var/lib/efm/dctm
  max_size_gb: 100

replication:
  mode: consensus
  replicas: 5
  quorum: 3

indexing:
  fields:
    - capsule_id
    - event_type
    - timestamp
  rebuild_interval_hours: 24

retention:
  policy: forever  # Never delete
  compression: lz4
  archive_after_days: 30
```

---

## References

- Volume I §2: Layer 0 Foundation
- Volume II §4: Execution Logging
- Appendix E: ZK-SP Audit Chain

---

*Everything leaves a trace. The trace is the truth.*
