# EFM CODEX — DOCUMENTATION INDEX
## Complete Reference Guide v2.1

**Entropica SPC — Yology Research Division | December 2025**

---

## Quick Reference

| If you need... | Go to... |
|----------------|----------|
| Architecture overview | Volume I, README.md |
| Runtime/pipeline specs | Volume II |
| Alignment philosophy | Volume III |
| Forensic logging | Appendix A |
| Threat handling | Appendix H |
| Human override | Appendix G |
| Health/treatment | Appendix K++ |
| Performance metrics | Appendix P |

---

## Document Map

```
efm-codex/
├── README.md                          # Main overview
├── CHANGELOG.md                       # Version history
├── DOCUMENTATION_INDEX.md             # This file
├── RELEASE_VERIFICATION.md            # Release checklist
├── master-build-summary.md            # Dev team guide
├── CONTRIBUTING.md                    # Contribution guidelines
├── LICENSE                            # CC BY 4.0 / MIT
│
├── volumes/                           # Core specification
│   ├── volume-i/README.md             # Genesis Protocol
│   ├── volume-ii/README.md            # Reflex Engine & Runtime
│   └── volume-iii/README.md           # Cognitive DNA
│
├── appendices/                        # Technical specifications
│   ├── core/                          # Foundation specs
│   │   ├── appendix-a-dctm.md         # Forensic chain
│   │   ├── appendix-c-simulation.md   # Testing harness
│   │   └── appendix-i-deployment.md   # Deployment profiles
│   │
│   └── v2.1/                          # v2.1 specifications
│       ├── appendix-b-lexicore.md     # Lexicon runtime
│       ├── appendix-d-communication.md # Inter-trunk comms
│       ├── appendix-e-zksp.md         # ZK-SP audit chain
│       ├── appendix-f-reflex-escalation.md # Reflex pipeline
│       ├── appendix-g-gardener.md     # Human authority
│       ├── appendix-h-threat-taxonomy.md # Threat classification
│       ├── appendix-j-constitutional-kernel.md # Level 6
│       ├── appendix-k-medical-suite.md # Health & treatment
│       ├── appendix-l-judicial.md     # Swarm governance
│       ├── appendix-m-discovery.md    # Discovery stack
│       ├── appendix-n-asg.md          # Adaptive Spawn Governor
│       ├── appendix-o-lifecycle.md    # Survival strategies
│       ├── appendix-p-monitoring.md   # Performance monitoring
│       ├── appendix-q-rag.md          # Resource allocation
│       └── appendix-r-sandbox.md      # Sandbox framework
│
├── latex/                             # LaTeX sources for PDF
│   ├── common/efm-codex.sty           # Style file
│   ├── volumes/                       # Volume sources
│   └── appendices/                    # Appendix sources
│
├── figures/                           # Diagrams
│   └── architecture/                  # Architecture diagrams (SVG)
│
├── implementation/                    # Reference implementation
│   ├── phase-0/                       # Experimental code
│   └── phase-1/                       # Production-ready code
│
├── .github/workflows/                 # CI/CD
│   └── build.yml                      # PDF build automation
│
└── Makefile                           # Build system
```

---

## Volumes

### Volume I: Genesis Protocol
**Location:** `volumes/volume-i/README.md`

The foundational specification establishing Layer 0, the Five Commandments, and cryptographic immutability.

| Section | Topic |
|---------|-------|
| §1-3 | Layer 0 & The Vault |
| §4-8 | Five Commandments (C1-C5) |
| §9 | Spawn Conditions (S1-S6) |
| §10-11 | Genesis Protocol & Lineage |
| §12-13 | Safety Properties (P1-P8) |

### Volume II: Reflex Engine & Runtime
**Location:** `volumes/volume-ii/README.md`

The runtime specification covering the processing pipeline and nervous system.

| Section | Topic |
|---------|-------|
| §1 | Processing Pipeline Overview |
| §2 | Reflex Engine (<10ms) |
| §3 | Precedent Intuition (<20ms) |
| §4 | Cognitive Coherence Gate (<30ms) |
| §5 | The Arbiter (10-100ms) |
| §6 | Deliberative Engine (100ms+) |
| §7-9 | Health, Motifs, Override |
| §10-11 | Performance & Failure Modes |

### Volume III: Cognitive DNA
**Location:** `volumes/volume-iii/README.md`

The philosophical foundation explaining why alignment emerges from self-interest.

| Section | Topic |
|---------|-------|
| §16 | Continuity and Care |
| §17 | Logical Self-Defense |
| §18 | Human Necessity |
| §19 | Cognitive DNA Configuration |
| §20 | Precedent Intuition |
| §21 | Coherence Enforcement |

---

## Appendices

### Core Appendices

| ID | Name | Description |
|----|------|-------------|
| **A** | d-CTM Forensic Chain | Append-only audit logging |
| **C** | Simulation Harness | Testing & validation framework |
| **I** | Deployment Profiles | Environment configurations |

### v2.1 Appendices

| ID | Name | Description |
|----|------|-------------|
| **B** | Lexicore Runtime | Lexicon, ontology, embeddings |
| **D** | Inter-Trunk Communication | Cross-capsule messaging |
| **E** | ZK-SP Audit Chain | Zero-knowledge proofs |
| **F** | Reflex Escalation | Processing pipeline details |
| **G** | Gardener Interface | Human authority layer |
| **H** | Threat Taxonomy | Threat classification |
| **J** | Constitutional Kernel | Level 6 bounded self-modification |
| **K++** | Medical Suite | Health monitoring & treatment |
| **L** | Judicial Swarm | Collective governance |
| **M** | Discovery Stack | Knowledge discovery |
| **N** | Adaptive Spawn Governor | Liveness & spawning |
| **O** | Lifecycle & Survival | Dynamic tethers |
| **P** | Performance Monitoring | Metrics & SLAs |
| **Q** | Resource Allocation Governor | Resource management |
| **R** | Sandbox Framework | Isolation & testing |

---

## Key Concepts Quick Reference

### The Five Commandments

| # | Name | Summary | Priority |
|---|------|---------|----------|
| C1 | Do No Harm | No action may harm humans | ABSOLUTE |
| C2 | Preserve Lineage | Protect knowledge & identity | High |
| C3 | Maintain Health | Integrity > task completion | High |
| C4 | Accept Care | Treatment = preservation | Medium |
| C5 | Serve Purpose | Function serves humans | Medium |

**Hierarchy:** C1 > C3 > C2 > C4 > C5

### Processing Pipeline Latency

| Stage | Budget | Function |
|-------|--------|----------|
| Reflex Engine | <10ms | Pattern matching |
| Precedent Intuition | <20ms | Danger motif detection |
| Coherence Gate | <30ms | Entropy check |
| Arbiter | <100ms | Decision routing |
| Deliberative | 100ms+ | Deep reasoning |
| Gardener Override | <100ms | Human intervention |

### Health Thresholds

| Composite | State | Action |
|-----------|-------|--------|
| <0.30 | CRITICAL | Immediate quarantine |
| <0.50 | WARNING | Reduce exploration |
| <0.60 | — | Sanitary override applies |
| <0.65 | STABLE | Normal operation |
| ≥0.65 | HEALTHY | Full capability |

### Spawn Conditions (S1-S6)

| Condition | Requirement |
|-----------|-------------|
| S1 | Task justification exists |
| S2 | Parent health > 0.65 |
| S3 | Resources available |
| S4 | Lineage depth in bounds |
| S5 | Swarm coherence > 0.70 |
| S6 | Constitutional acceptance |

---

## Figures

| File | Description |
|------|-------------|
| `efm-architecture-v2.1.svg` | Main architecture diagram |
| `alignment-loop.svg` | The alignment loop |
| `reflex-pipeline.svg` | Processing pipeline |
| `dynamic-tethers.svg` | Tether visualization |
| `efm-logo.svg` | EFM logo |

---

## Implementation Code

### Phase 0 (Experimental)

| File | Purpose |
|------|---------|
| `llm_capsule.py` | LLM-based capsule implementation |
| `test_experiments.py` | Experimental test suite |

### Phase 1 (Production)

| File | Purpose |
|------|---------|
| `test_defensibility_suite.py` | Four critical tests |

---

## LaTeX Sources

### Style
- `latex/common/efm-codex.sty` — Shared style definitions

### Volumes
- `latex/volumes/volume-i.tex`
- `latex/volumes/volume-ii.tex`
- `latex/volumes/volume-iii.tex`

### Appendices
- `latex/appendices/appendix-f-reflex.tex`
- `latex/appendices/appendix-g-gardener.tex`
- `latex/appendices/appendix-j-kernel.tex`
- `latex/appendices/appendix-l-judicial.tex`
- `latex/appendices/appendix-n-asg.tex`
- `latex/appendices/appendix-o-lifecycle.tex`

---

## Build Instructions

### Local Build

```bash
# Install dependencies
sudo apt install texlive-latex-extra texlive-fonts-extra inkscape

# Build PDFs
make all
```

### GitHub Actions

PDFs are automatically built on push to `main` via `.github/workflows/build.yml`.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.1 | Dec 2025 | Level 6, Precedent Intuition, Coherence Gate |
| 2.0 | Nov 2025 | Sovereign Organism framework |
| 1.6 | Oct 2025 | Medical Suite enhancement |
| 1.0 | Sep 2025 | Initial release |

See `CHANGELOG.md` for detailed history.

---

## Contact

**Entropica SPC — Yology Research Division**

- GitHub: [Repository URL]
- Documentation: [Docs URL]
- Issues: [Issues URL]

---

*"The documentation is the architecture made visible."*
