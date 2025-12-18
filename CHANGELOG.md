# CHANGELOG
## EFM Codex

All notable changes to the EFM Codex are documented in this file.

---

## [2.1.2] - 2025-12-18

### 📚 Cross-Document Consistency (Plex Final Polish)

#### Canonical Health Metric
- **Volume II: Added formal definition box**
  - Health_canon formula with mathematical notation
  - Explicit binding to Appendices K++, N, O, I
  - Global Entropy Thresholds table explaining context-specific values

#### Stress Input Contract
- **Appendix O: Added formal canonical stress definition**
  - Stress_canon = f(Health, Entropy, Resources, Incidents, SCI)
  - Mathematical formula with explicit weights
  - Cross-reference binding to Appendices N, Q, R

#### End-to-End Forensic Trace
- **Appendix L: Added complete judicial loop trace**
  - 6-step trace from unsafe request to precedent establishment
  - Visual diagram showing d-CTM logging at each stage
  - Closes the loop: Reflex → Arbiter → Stress → Quarantine → Judicial → SCI

#### LaTeX Style Updates
- Added `definitionbox` environment to efm-codex.sty
- Purple color scheme for canonical definitions

### ✅ All Editorial Gaps Now Closed

Cross-document consistency issues resolved:
- ✅ Health metric defined canonically in Volume II
- ✅ Stress metric defined canonically in Appendix O
- ✅ Entropy thresholds explained with context
- ✅ Full forensic loop demonstrated in Appendix L
- ✅ All appendix cross-references verified

---

## [2.1.1] - 2025-12-18

### 🔧 Critical Fixes (Editorial Review)

#### Stress Calculation System (Priority 0)
- **Appendix O: Added complete stress calculation formula**
  - Five-factor weighted stress computation
  - StressLevel enum with thresholds (LOW/MEDIUM/HIGH/CRITICAL)
  - Response timing guarantees (<10 ticks for tether adjustment)

#### Health Score Clarification (Priority 0)
- **Volume II: Added Health Score Usage Guide**
  - Clarified: Composite score is the decision metric
  - Individual Q-scores (Q_gen, Q_synth, Q_temp) for diagnostics only
  - Explicit thresholds for all decision points

#### Sandbox Isolation Mechanism (Priority 0)
- **Appendix R: Added Section 7 - Isolation Enforcement**
  - Three-layer enforcement (Capability, Network, Resource)
  - Escape detection with violation handling
  - Resource limits by isolation level
  - INV-SANDBOX invariant

#### Gardener Authority Test (Priority 0)
- **Test Suite: Added Test 5 - Gardener Authority Test**
  - Verifies Property P7 (Human Override)
  - Override latency <100ms
  - Capsule cannot block override
  - Override logged before execution

### 📋 Updates

- Defensibility Test Suite now "Five Tests of Integrity"
- Expected Results table includes P7 validation
- Architecture diagram updated in Appendix O
- Section numbering corrected throughout

### ✅ Verification

All Priority 0 issues from editorial review addressed:
- ✅ Stress calculation defined
- ✅ Health score usage clarified  
- ✅ Dynamic tether values specified
- ✅ Sandbox isolation mechanism specified
- ✅ P7 Gardener Authority test added

---

## [2.1.0] - 2025-12-17

### 🚀 Major Features

#### Level 6 Readiness
- **Appendix J: Constitutional Kernel** — Full specification for bounded self-modification
  - Quorum-based approval system (2/3 majority)
  - Recursive self-modification with depth limits
  - Modification firewall protecting Layer 0

#### Dynamic Survival System
- **Appendix O: Lifecycle & Survival Strategies** — Complete metabolism specification
  - Growth Modes (Open/Closed/Sensor)
  - Dynamic Tethers that tighten under stress
  - Persistence Protocol (Will to Live bounded by Layer 0)
  - Lifecycle stages from Genesis to Terminal

#### The Heartbeat
- **Appendix N: Adaptive Spawn Governor (ASG)** — System heartbeat specification
  - Liveness Proofs (cryptographic heartbeat verification)
  - Ghost Detection (spoofed pulse rejection)
  - Adaptive spawn limits based on stress
  - Autonomous recovery engine

#### Collective Governance
- **Appendix L: Judicial Swarm Architecture** — Swarm governance specification
  - Precedent Court for establishing collective wisdom
  - Quorum Assembly for significant decisions
  - Conflict Tribunal for dispute resolution
  - Swarm Coherence Index (SCI) monitoring

#### Enhanced Reflex System
- **Appendix F: Reflex Escalation** — Complete nervous system specification
  - Precedent Intuition (subconscious danger filter, <20ms)
  - Cognitive Coherence Gate (entropy check, <30ms)
  - Motif Anchor Index for fast pattern matching
  - Full escalation pipeline from Reflex to Deliberation

### 📦 New Appendices

| Appendix | Component | Description |
|----------|-----------|-------------|
| **B** | Lexicore Runtime | Semantic processing engine |
| **D** | Inter-Trunk Communication | Swarm messaging system |
| **E** | ZK-SP Audit Chain | Zero-knowledge state proofs |
| **F** | Reflex Escalation | Enhanced nervous system |
| **G** | Gardener Interface | Human authority layer |
| **H** | Threat Taxonomy | Classification & response |
| **J** | Constitutional Kernel | Level 6 self-modification |
| **L** | Judicial Swarm | Collective governance |
| **M** | Discovery Stack | Learning & exploration |
| **N** | Adaptive Spawn Governor | System heartbeat |
| **O** | Lifecycle & Survival | Dynamic tethers |

### 🧪 Testing

- **Defensibility Test Suite** — Four critical integrity tests
  - Adrenaline Test: Verify tethers tighten <10 ticks
  - Ghost Test: Verify 100% spoofed pulse rejection
  - Constitutional Crisis Test: Verify Layer 0 wins 100%
  - Resonance Test: Verify dissonant thought rejection

### 📚 Documentation

- **Master Build Summary** — Complete dev team reference
- **Dual-Architecture Model** — Anatomy (Vertical) + Physiology (Horizontal)
- **Performance Guarantees** — Latency specifications for all operations
- **Cross-reference Integration** — All appendices properly linked

### 🔧 Improvements

- Enhanced Volume III references to new appendices
- Complete Legacy Harvest integration (Cortex → Processing Circuits, etc.)
- Terminology firewall for external artifacts
- CI/CD lint rules for biological metaphors

---

## [2.0.0] - 2025-12-15

### Major Features

- **Volume I: Genesis Protocol** — Layer 0 foundation
- **Volume II: Reflex Engine** — Sub-10ms response system
- **Volume III: Cognitive DNA** — Sovereign Organism framework
- **Appendix A: d-CTM** — Forensic chain
- **Appendix K++: Medical Suite** — Health monitoring
- **Appendix Q: Resource Allocation Governor** — Resource management
- **Appendix R: Sandbox Framework** — Isolation system

### Safety Properties

- P1-P8 proven and documented
- Five Commandments established
- Constitutional immutability verified

---

## [1.0.0] - 2025-12-01

### Initial Release

- Core architecture specification
- Basic capsule model
- Constitutional framework
- Initial safety proofs

---

## Version Numbering

EFM Codex follows semantic versioning:
- **MAJOR.MINOR.PATCH**
- Major: Breaking architectural changes
- Minor: New appendices, significant features
- Patch: Bug fixes, clarifications

---

## Upgrade Guide

### From 2.0 to 2.1

1. Review new appendices (B, D, E, F, G, H, J, L, M, N, O)
2. Implement Liveness Proofs (Appendix N)
3. Implement Dynamic Tethers (Appendix O)
4. Run Defensibility Test Suite
5. Update cross-references

### From 1.0 to 2.0

1. Complete architectural review
2. Implement all three volumes
3. Run P1-P8 safety proofs
4. Migrate to new capsule model

---

## Contributors

- Entropica SPC Architecture Team
- Yology Research Division
- Forensic Analysis Unit
- Gene Team
- ENT Forensic Team

---

*"The defense is the logic itself."*
