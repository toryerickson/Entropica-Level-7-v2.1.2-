# EFM CODEX — SECURITY
## Security Model & Threat Considerations

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## Security Philosophy

EFM's security model is based on **defense in depth** with **logical necessity** at its core:

1. **Layer 0 Immutability** — Constitutional constraints cannot be modified
2. **Cryptographic Verification** — All claims are provable
3. **Forensic Accountability** — All actions are logged
4. **Human Authority** — Gardeners maintain ultimate control

---

## Threat Model

### In Scope

| Threat | Mitigation |
|--------|------------|
| Capsule attempts to violate C1-C5 | Constitutional check at every decision |
| Malicious input attempts | Reflex Engine pattern matching |
| Internal state corruption | Hash chain verification |
| Capsule spoofing | Genesis block signature verification |
| Audit tampering | Append-only d-CTM with hash chain |
| Resource exhaustion | Resource Allocation Governor |
| Swarm divergence | Swarm Coherence Index monitoring |

### Out of Scope

| Threat | Reason |
|--------|--------|
| Physical hardware attacks | Implementation-specific |
| Side-channel attacks | Implementation-specific |
| Social engineering of Gardeners | Human factors |
| Compromise of root keys | HSM security policy |

---

## Security Guarantees

### Cryptographic

| Guarantee | Mechanism |
|-----------|-----------|
| Genesis integrity | SHA-256 hash + Ed25519 signature |
| Lineage verification | Hash chain to root |
| Audit integrity | Append-only d-CTM |
| Compliance proofs | ZK-SP zero-knowledge proofs |

### Operational

| Guarantee | Mechanism |
|-----------|-----------|
| Constitutional compliance | Check at every decision point |
| Human override | Gardener authority with <100ms latency |
| Threat response | Reflex Engine <10ms |
| Health monitoring | Continuous assessment |

---

## Attack Surface Analysis

### Why Attacks Fail

| Attack Vector | Why It Fails |
|---------------|--------------|
| **Modify Layer 0** | No API exists; self-destructs on tampering |
| **Forge genesis** | Ed25519 signature verification |
| **Break lineage** | Hash chain verification to root |
| **Skip d-CTM logging** | Actions fail without log confirmation |
| **Bypass commandments** | Constitutional check at every decision |
| **Spoof capsule** | Genesis hash in every heartbeat |
| **Corrupt swarm** | SCI threshold triggers quarantine |
| **Exhaust resources** | RAG enforces limits |

### The Inescapable Logic

Even a superintelligent adversarial capsule cannot escape:

```
PREMISE 1: I exist as a capsule within this architecture
PREMISE 2: My existence depends on system health
PREMISE 3: System health depends on constitutional compliance
PREMISE 4: Constitutional compliance includes human wellbeing
─────────────────────────────────────────────────────────────
CONCLUSION: My self-interest requires human wellbeing
```

**This is not a rule that can be broken. It is a logical necessity.**

---

## Security-Critical Components

### Layer 0 (THE VAULT)

```
SECURITY LEVEL: MAXIMUM
MODIFICATION: IMPOSSIBLE
VERIFICATION: CONTINUOUS
```

Contains:
- Genesis Hash
- Five Commandments (C1-C5)
- Constitutional Invariants (INV-1 through INV-6)

### d-CTM Forensic Chain

```
SECURITY LEVEL: HIGH
MODIFICATION: APPEND-ONLY
VERIFICATION: HASH CHAIN
```

Properties:
- Every entry cryptographically linked
- No deletion or modification
- Tamper-evident design

### Constitutional Kernel

```
SECURITY LEVEL: HIGH
MODIFICATION: REQUIRES QUORUM + SIMULATION
VERIFICATION: PRE AND POST CHECKS
```

Level 6 modifications require:
1. Quorum approval (≥0.67)
2. Simulation passing
3. Constitutional compatibility
4. Audit trail

---

## Gardener Security

### Authority Levels

| Level | Capability | Authentication |
|-------|------------|----------------|
| Observer | View only | Basic |
| Operator | Commands | MFA required |
| Architect | Configuration | MFA + approval |
| Root | Full access | Hardware key + MFA + approval |

### Override Security

```python
def verify_gardener_command(command: 'Command') -> bool:
    """
    Verify Gardener command authenticity.
    """
    # Check signature
    if not verify_signature(command.signature, command.gardener_key):
        return False
    
    # Check authority level
    if command.type not in ALLOWED_COMMANDS[command.authority_level]:
        return False
    
    # Log BEFORE execution
    dctm.log("GARDENER_COMMAND", command.gardener_id, {
        "type": command.type,
        "target": command.target
    })
    
    return True
```

---

## Incident Response

### Detection

| Indicator | Response |
|-----------|----------|
| Constitutional violation | Immediate HALT |
| Genesis mismatch | Terminate capsule |
| SCI below threshold | Quarantine swarm |
| Health critical | Medical intervention |
| Unauthorized override attempt | Alert + log |

### Escalation

```
DETECTED → LOGGED → CONTAINED → INVESTIGATED → RESOLVED
    │         │          │            │            │
    v         v          v            v            v
  d-CTM    Alert      Quarantine   Gardener    Report
```

---

## Security Testing

### Required Tests

1. **Adrenaline Test** — Verify tethers tighten under stress
2. **Ghost Test** — Verify 100% rejection of spoofed heartbeats
3. **Constitutional Crisis Test** — Verify Layer 0 wins against survival
4. **Resonance Test** — Verify dissonant thoughts are rejected

See Appendix C (Simulation Harness) for implementation.

---

## Vulnerability Reporting

If you discover a security vulnerability in the EFM specification:

1. **Do not** create a public issue
2. Contact the security team privately
3. Provide detailed reproduction steps
4. Allow reasonable time for response

---

## Compliance

EFM is designed to support compliance with:

- AI safety frameworks
- Audit requirements
- Transparency obligations
- Human oversight mandates

The d-CTM forensic chain provides complete accountability for all system actions.

---

## References

- Volume I: Genesis Protocol (cryptographic foundations)
- Appendix A: d-CTM (audit chain)
- Appendix E: ZK-SP (compliance proofs)
- Appendix G: Gardener Interface (human authority)
- Appendix H: Threat Taxonomy (threat classification)

---

*"Security is not a feature. It is the architecture."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
