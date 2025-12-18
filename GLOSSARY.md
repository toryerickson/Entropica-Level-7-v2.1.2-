# EFM CODEX — GLOSSARY
## Key Terms & Definitions

**Version 2.1 | Entropica SPC — Yology Research Division | December 2025**

---

## A

**Arbiter**
: Decision-routing component that matches requests against precedents and constitutional constraints. Latency: 10-100ms. See Volume II §5.

**ASG (Adaptive Spawn Governor)**
: System controlling capsule creation and liveness monitoring. Enforces spawn conditions S1-S6. See Appendix N.

## B

**Bounded Self-Modification**
: Level 6 capability allowing capsules to modify themselves within constitutional constraints. Requires quorum approval. See Appendix J.

## C

**Capsule**
: The fundamental unit of computation in EFM. Each capsule has a genesis block, health metrics, and constitutional binding.

**Cognitive DNA**
: The configuration defining a capsule's semantic processing: Lexicon, Ontology, and Embeddings. See Appendix B.

**Coherence Gate**
: Processing layer that rejects thoughts causing entropy > 0.8. Latency: <30ms. See Volume II §4.

**Commandments (C1-C5)**
: The Five Commandments—inviolable constraints defining capsule behavior. Hierarchy: C1 > C3 > C2 > C4 > C5. See Volume I.

**Constitutional Kernel**
: The constraint interpreter and enforcer, implementing Level 6 bounded self-modification. See Appendix J.

## D

**d-CTM (Distributed Capsule Transaction Memory)**
: Append-only forensic chain logging all system events. See Appendix A.

**Deliberative Engine**
: Full reasoning system for complex decisions that cannot be resolved by faster layers. Latency: 100ms+. See Volume II §6.

**Dissonant**
: A thought rejected by the Coherence Gate because it would cause excessive entropy.

**Dynamic Tethers**
: Stress-responsive constraints that tighten under threat and relax in safety. See Appendix O.

## E

**Entropy**
: Measure of system disorder. High entropy indicates instability. Threshold for rejection: 0.8.

## F

**Five Commandments**
: See Commandments.

## G

**Gardener**
: Human operator with authority over capsule systems. Can issue overrides, quarantine, or terminate capsules. See Appendix G.

**Genesis Block**
: Cryptographically sealed record of capsule creation. Contains identity, lineage, and constitutional binding. See Volume I §2.

**Genesis Hash**
: SHA-256 hash anchoring a capsule's identity to its creation moment.

## H

**Health Composite**
: Weighted score combining Q_gen, Q_synth, Q_temp, and Entropy. Formula: 0.40×Q_gen + 0.35×Q_synth + 0.25×Q_temp - 0.20×Entropy.

**Health Thresholds**
: Critical <0.30, Warning <0.50, Stable <0.65, Healthy ≥0.65.

## I

**Immutability**
: Property of Layer 0 that makes constitutional constraints unmodifiable. No API exists to change them.

**Invariant (INV-1 through INV-6)**
: Logical guarantees that must always hold. Violation triggers system halt. See Volume I §3.

## J

**Judicial Swarm**
: Collective governance system for establishing precedents through multi-capsule deliberation. See Appendix L.

## K

**K++ (Medical Suite)**
: Treatment system for degraded capsules. Implements care-based approach. See Appendix K++.

## L

**Layer 0**
: The immutable foundation containing Genesis Hash, Five Commandments, and Constitutional Invariants. See Volume I §1.

**Level 6**
: Capability level allowing bounded self-modification within constitutional constraints.

**Lexicore**
: Runtime system for semantic processing. See Appendix B.

**Lineage**
: The chain of parent-child relationships from a capsule to the root. Must be cryptographically verifiable.

## M

**Medical Suite**
: See K++.

**Motif**
: A pattern for recognition, used by Reflex Engine and Precedent Intuition.

## N

**Nervous System**
: Collective term for the processing pipeline (Reflex, Intuition, Coherence, Arbiter, Deliberative). See Volume II.

## O

**Override**
: Gardener command that supersedes normal capsule operation. Types: PAUSE, HALT, QUARANTINE, TERMINATE.

## P

**P1-P8**
: Safety properties that EFM guarantees. See Volume I §12.

**Precedent Intuition**
: Subconscious danger filter that rejects known-dangerous patterns before deliberation. Latency: <20ms. See Volume II §3.

**Processing Pipeline**
: The sequence: Reflex (<10ms) → Intuition (<20ms) → Coherence (<30ms) → Arbiter (<100ms) → Deliberative (100ms+).

## Q

**Q_gen, Q_synth, Q_temp**
: Health metrics measuring generative coherence, synthesis quality, and temporal consistency.

**Quorum**
: Required consensus for Level 6 modifications. Default threshold: 0.67.

## R

**RAG (Resource Allocation Governor)**
: System managing compute, memory, and other resources across capsules. See Appendix Q.

**Reflex Engine**
: Fastest processing layer—pure pattern matching with no deliberation. Latency: <10ms. See Volume II §2.

## S

**S1-S6**
: Spawn conditions that must be satisfied for capsule creation. See Volume I §9.

**Sanitary Override**
: Medical intervention applied when capsule health < 0.6. Capsule loses consent rights.

**SCI (Swarm Coherence Index)**
: Measure of collective alignment across capsules. Threshold: >0.70.

**Sovereign Organism**
: Philosophical framework where alignment emerges from rational self-interest. See Volume III.

**Spawn**
: The process of creating a new capsule. Governed by ASG and conditions S1-S6.

**Swarm**
: Collection of capsules operating together with shared coherence.

## T

**Tether**
: Constraint parameter that can dynamically adjust based on stress level. See Appendix O.

**Treatment**
: Medical intervention for degraded capsules. Types: Drift Correction, Coherence Restoration, Constitutional Reaffirmation.

## V

**Vault**
: See Layer 0.

## Z

**ZK-SP (Zero-Knowledge State Proof)**
: Cryptographic proof of compliance without revealing internal state. See Appendix E.

---

## Notation

| Symbol | Meaning |
|--------|---------|
| C1-C5 | The Five Commandments |
| S1-S6 | Spawn Conditions |
| P1-P8 | Safety Properties |
| INV-1 to INV-6 | Constitutional Invariants |
| Q_gen | Generative coherence metric |
| Q_synth | Synthesis quality metric |
| Q_temp | Temporal consistency metric |
| SCI | Swarm Coherence Index |

---

## Quick Reference: Latency Budgets

| Component | Budget |
|-----------|--------|
| Reflex Engine | <10ms |
| Precedent Intuition | <20ms |
| Coherence Gate | <30ms |
| Arbiter | <100ms |
| Gardener Override | <100ms |
| d-CTM Write | <5ms |

---

*"Precise language enables precise thinking."*

**Entropica SPC — Yology Research Division**  
**December 2025 • Version 2.1**
