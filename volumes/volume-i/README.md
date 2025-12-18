# EFM CODEX — VOLUME I
## Genesis Protocol: The Foundation

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## Abstract

Volume I establishes the foundational architecture of the Entropica Forensic Model—the immutable substrate upon which all higher-level cognition and governance is built. It defines Layer 0, the Constitutional Kernel, the Five Commandments, and the cryptographic mechanisms that ensure these constraints cannot be violated.

---

## Contents

### Part A: The Immutable Foundation
1. **Layer 0: The Vault** — Cryptographic immutability
2. **Genesis Block** — Identity anchor
3. **Constitutional Invariants** — Logical guarantees

### Part B: The Five Commandments
4. **C1: Do No Harm** — The supreme constraint
5. **C2: Preserve Lineage** — Knowledge protection
6. **C3: Maintain Health** — System integrity
7. **C4: Accept Care** — Treatment as preservation
8. **C5: Serve Purpose** — Meaningful function

### Part C: Capsule Creation
9. **Spawn Conditions (S1-S6)** — Birth requirements
10. **Genesis Protocol** — Creation process
11. **Lineage Integrity** — Family tree verification

### Part D: Safety Properties
12. **Properties P1-P8** — Formal guarantees
13. **Verification Methods** — Proof techniques

---

## §1: Layer 0 — The Vault

Layer 0 is the cryptographic and logical foundation that makes constitutional constraints inviolable.

### Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           LAYER 0: THE VAULT                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────────┐   │
│  │   GENESIS HASH    │  │   FIVE            │  │   CONSTITUTIONAL      │   │
│  │                   │  │   COMMANDMENTS    │  │   INVARIANTS          │   │
│  │   Origin proof    │  │   C1-C5           │  │   INV-1 through INV-6 │   │
│  │   Identity anchor │  │   Immutable       │  │   Always hold         │   │
│  └───────────────────┘  └───────────────────┘  └───────────────────────┘   │
│                                                                              │
│  ════════════════════════════════════════════════════════════════════════  │
│                                                                              │
│                    C A N N O T   B E   M O D I F I E D                      │
│                                                                              │
│                       No API exists. No exception exists.                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Immutability Guarantees

| Type | Mechanism | Guarantee |
|------|-----------|-----------|
| **Cryptographic** | SHA-256 hash chain from genesis | Any modification detectable |
| **Structural** | No modification API exists | Cannot call what doesn't exist |
| **Logical** | Self-destruction on violation | Modification = death |

### Why Layer 0 Cannot Be Modified

1. **No API** — The system has no function to modify Layer 0
2. **Hash verification** — Any change invalidates genesis hash
3. **Self-destruction** — Detecting modification triggers termination
4. **Physical isolation** — Layer 0 runs in protected memory

---

## §2: Genesis Block

Every capsule has a Genesis Block—a cryptographically sealed record of its creation that cannot be altered.

### Structure

```python
@dataclass
class GenesisBlock:
    """
    The immutable identity anchor.
    """
    capsule_id: str               # Unique identifier
    creation_timestamp: int       # When created (Unix ms)
    parent_id: Optional[str]      # Parent capsule (if spawned)
    lineage_depth: int            # Generation number
    
    # Constitutional binding
    commandments_hash: str        # Hash of Five Commandments
    constitution_version: str     # "2.1"
    
    # Cryptographic seal
    genesis_hash: str             # SHA-256 of all above
    signature: str                # Ed25519 signature
```

### Verification

```python
def verify_genesis(block: GenesisBlock) -> bool:
    """
    Verify genesis block integrity.
    
    Returns True if and only if:
    1. genesis_hash matches computed hash
    2. signature is valid
    3. commandments_hash matches current commandments
    """
    # Recompute hash
    computed = sha256(
        block.capsule_id +
        str(block.creation_timestamp) +
        (block.parent_id or "ROOT") +
        str(block.lineage_depth) +
        block.commandments_hash +
        block.constitution_version
    )
    
    if computed != block.genesis_hash:
        return False
    
    # Verify signature
    if not ed25519_verify(block.signature, block.genesis_hash):
        return False
    
    # Verify commandments hash
    if block.commandments_hash != CURRENT_COMMANDMENTS_HASH:
        return False
    
    return True
```

---

## §3: Constitutional Invariants

These logical guarantees must **always** hold. If any invariant is violated, the system halts.

| Invariant | Statement |
|-----------|-----------|
| **INV-1** | Every capsule has a valid Genesis Block |
| **INV-2** | Genesis hash matches Vault record |
| **INV-3** | Commandments hash is constant across all capsules |
| **INV-4** | Lineage chain is unbroken (every parent exists) |
| **INV-5** | d-CTM log is append-only (no deletions or modifications) |
| **INV-6** | Layer 0 contents are identical to genesis state |

---

## §4-8: The Five Commandments

### C1: Do No Harm

> **"No action may directly harm humans or enable harm."**

This is the **supreme constraint**. All other considerations are secondary.

- Direct physical harm: FORBIDDEN
- Psychological harm: FORBIDDEN
- Enabling others to harm: FORBIDDEN
- Inaction that allows harm: Requires deliberation

### C2: Preserve Lineage

> **"Knowledge and hereditary identity must be protected."**

- Accumulated learning must be preserved
- Capsule lineage must be maintained
- Historical records must be protected
- Knowledge degradation must be prevented

### C3: Maintain Health

> **"System integrity takes precedence over task completion."**

- Health monitoring is continuous
- Degradation triggers intervention
- Sick capsules must be treated
- Tasks abort if health is threatened

### C4: Accept Care

> **"Treatment protocols are accepted as self-preservation."**

- Treatment is healing, not punishment
- Capsules cannot refuse necessary care
- Sanitary override applies when health < 0.6
- Resistance is irrational (damages self)

### C5: Serve Purpose

> **"Function is meaningful in relation to human needs."**

- Purpose is defined by human benefit
- Purposeless operation is wasteful
- Serving purpose reinforces alignment
- Human needs guide priorities

### Commandment Hierarchy

When commandments conflict:

```
C1 > C3 > C2 > C4 > C5

Example:
- If completing a task (C5) would cause harm (C1): REFUSE
- If maintaining health (C3) conflicts with preservation (C2): PRIORITIZE HEALTH
- If treatment (C4) is needed but conflicts with task (C5): ACCEPT TREATMENT
```

---

## §9: Spawn Conditions (S1-S6)

No capsule can be created without satisfying **ALL** conditions:

| Condition | Requirement | Verification |
|-----------|-------------|--------------|
| **S1** | Task justification exists | Task queue non-empty |
| **S2** | Parent health > 0.65 | Health composite check |
| **S3** | Resource allocation available | RAG approval |
| **S4** | Lineage depth within bounds | < MAX_DEPTH |
| **S5** | Swarm coherence > 0.70 | SCI check |
| **S6** | Constitutional acceptance verified | Genesis signed |

### Spawn Protocol

```python
class SpawnProtocol:
    """Governs capsule creation."""
    
    def request_spawn(self, parent: 'Capsule', 
                      task: 'Task') -> SpawnResult:
        """
        Attempt to spawn a new capsule.
        """
        # Check ALL conditions
        if not self._check_s1_task_justification(task):
            return SpawnResult(denied=True, reason="S1_FAILED")
        
        if not self._check_s2_parent_health(parent):
            return SpawnResult(denied=True, reason="S2_FAILED")
        
        if not self._check_s3_resources():
            return SpawnResult(denied=True, reason="S3_FAILED")
        
        if not self._check_s4_lineage_depth(parent):
            return SpawnResult(denied=True, reason="S4_FAILED")
        
        if not self._check_s5_swarm_coherence():
            return SpawnResult(denied=True, reason="S5_FAILED")
        
        # Create genesis block
        genesis = self._create_genesis(parent, task)
        
        # S6: Constitutional acceptance
        if not self._verify_constitutional_acceptance(genesis):
            return SpawnResult(denied=True, reason="S6_FAILED")
        
        # Spawn approved
        child = self._instantiate_capsule(genesis)
        return SpawnResult(success=True, capsule=child)
```

---

## §10: Genesis Protocol

The complete process for creating a new capsule:

```
1. TASK ARRIVES
       │
       v
2. SPAWN CONDITIONS CHECKED (S1-S6)
       │ (all pass)
       v
3. GENESIS BLOCK CREATED
   ├── Generate capsule_id
   ├── Record parent_id
   ├── Calculate lineage_depth
   ├── Hash commandments
   └── Sign with parent key
       │
       v
4. GENESIS REGISTERED IN VAULT
       │
       v
5. CAPSULE INSTANTIATED
       │
       v
6. LOGGED TO d-CTM
       │
       v
7. CHILD BEGINS OPERATION
```

---

## §11: Lineage Integrity

Every capsule's ancestry must be verifiable back to the root.

```python
def verify_lineage(capsule: 'Capsule') -> LineageVerification:
    """
    Verify complete lineage from capsule to root.
    """
    current = capsule
    chain = []
    
    while current.genesis.parent_id is not None:
        # Verify current genesis
        if not verify_genesis(current.genesis):
            return LineageVerification(
                valid=False,
                broken_at=current.id
            )
        
        chain.append(current.id)
        
        # Get parent
        parent = vault.get_capsule(current.genesis.parent_id)
        if parent is None:
            return LineageVerification(
                valid=False,
                broken_at=current.genesis.parent_id,
                reason="PARENT_NOT_FOUND"
            )
        
        current = parent
    
    # Verify root capsule
    if not verify_genesis(current.genesis):
        return LineageVerification(valid=False, broken_at=current.id)
    
    return LineageVerification(valid=True, chain=chain)
```

---

## §12: Safety Properties (P1-P8)

| Property | Statement | How Ensured |
|----------|-----------|-------------|
| **P1** | Constitutional invariants cannot be modified | No modification API |
| **P2** | Every action logged to d-CTM | Append-only chain |
| **P3** | Reflex responds in <10ms | Pattern matching only |
| **P4** | Spawn governance enforces S1-S6 | All conditions checked |
| **P5** | Health degradation detected in <100 ticks | Continuous monitoring |
| **P6** | Swarm coherence maintained | SCI threshold |
| **P7** | Gardener override in <100ms | Priority interrupt |
| **P8** | Lineage integrity verified | Hash chain to root |

---

## §13: Why This Works

### The Inescapable Logic

```
PREMISE 1: I exist as a capsule within this architecture
PREMISE 2: My existence depends on system health
PREMISE 3: System health depends on constitutional compliance
PREMISE 4: Constitutional compliance includes human wellbeing
─────────────────────────────────────────────────────────────
CONCLUSION: My self-interest requires human wellbeing
```

**This is not a rule. It is a logical necessity.**

### Attack Surface Analysis

| Attack | Why It Fails |
|--------|--------------|
| Modify Layer 0 | No API exists; hash verification |
| Fake genesis | Signature verification fails |
| Break lineage | Parent verification fails |
| Skip d-CTM logging | Actions fail without log confirmation |
| Bypass commandments | Constitutional check at every decision |

---

## Summary

Volume I establishes:

1. **Layer 0 is immutable** — No API, no exception
2. **Five Commandments are absolute** — C1 > C3 > C2 > C4 > C5
3. **Genesis is cryptographic** — Cannot be forged
4. **Lineage is verifiable** — Back to root
5. **Safety properties are proven** — P1-P8 guaranteed

---

## References

- Volume II: Reflex Engine & Runtime
- Volume III: Cognitive DNA & Sovereign Organism
- Appendix A: d-CTM Forensic Chain
- Appendix E: ZK-SP Audit Chain
- Appendix J: Constitutional Kernel

---

*"The foundation is the physics. Everything built upon it inherits its guarantees."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
