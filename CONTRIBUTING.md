# Contributing to the EFM Codex

Thank you for your interest in contributing to the Entropica Forensic Model Codex. This document provides guidelines for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How to Contribute](#how-to-contribute)
3. [Areas of Interest](#areas-of-interest)
4. [Contribution Process](#contribution-process)
5. [Style Guidelines](#style-guidelines)
6. [Review Process](#review-process)

---

## Code of Conduct

### Our Commitment

We are committed to providing a welcoming and inclusive environment for all contributors. We expect all participants to:

- Be respectful and considerate
- Focus on constructive feedback
- Accept responsibility for mistakes
- Prioritize the community's best interests

### Scope

This code applies to all project spaces, including issues, pull requests, discussions, and any other communication channels.

---

## How to Contribute

### Types of Contributions

We welcome contributions in several areas:

1. **Documentation Improvements**
   - Clarifications and corrections
   - Additional examples
   - Translations

2. **Technical Contributions**
   - Bug fixes
   - New features (with discussion)
   - Performance improvements
   - Test coverage expansion

3. **Research Contributions**
   - Formal verification improvements
   - Alternative proof strategies
   - Attack vector analysis
   - Comparative analysis

4. **Community Contributions**
   - Answering questions
   - Reviewing pull requests
   - Writing tutorials

---

## Areas of Interest

We are particularly interested in contributions in these areas:

### High Priority

| Area | Description | Skills Needed |
|------|-------------|---------------|
| Formal Verification | Proofs of safety properties P1-P16 | TLA+, Coq, formal methods |
| LLM Integration | Testing with real LLM backends | Python, LLM APIs |
| Attack Analysis | New attack vectors and defenses | Security research |
| Performance | Optimization of critical paths | Systems programming |

### Medium Priority

| Area | Description | Skills Needed |
|------|-------------|---------------|
| Documentation | Clarity improvements | Technical writing |
| Examples | Real-world use cases | Domain expertise |
| Visualization | Architecture diagrams | Design tools |
| Testing | Edge cases and stress tests | Testing frameworks |

### Exploratory

| Area | Description | Skills Needed |
|------|-------------|---------------|
| Alternative Architectures | Variations on core design | Architecture design |
| Cross-Platform | Ports to other languages | Multi-language |
| Hardware Integration | HSM/TEE integration | Hardware security |

---

## Contribution Process

### For Documentation

1. Fork the repository
2. Create a branch: `docs/your-change`
3. Make your changes
4. Submit a pull request
5. Respond to review feedback

### For Code

1. **Discuss First**: Open an issue to discuss significant changes
2. Fork the repository
3. Create a branch: `feature/your-feature` or `fix/your-fix`
4. Write tests for your changes
5. Ensure all tests pass
6. Submit a pull request
7. Respond to review feedback

### For Research

1. Open an issue describing your research direction
2. Share preliminary findings for discussion
3. If approved, submit a pull request with:
   - Research document
   - Supporting evidence/proofs
   - Integration recommendations

---

## Style Guidelines

### Documentation

- Use clear, concise language
- Include examples where helpful
- Follow existing formatting conventions
- Use proper Markdown syntax
- Include diagrams for complex concepts

### Code

```python
# Python Style Guidelines

# Use descriptive names
def calculate_spawn_limit(stress_level: StressLevel) -> int:
    """
    Calculate spawn limit based on stress level.
    
    Args:
        stress_level: Current system stress level
        
    Returns:
        Maximum number of spawns allowed
    """
    # Implementation
    pass

# Use type hints
def process_input(user_input: str) -> Tuple[str, Dict[str, Any]]:
    pass

# Document all public functions
# Include examples in docstrings
# Write unit tests for all functions
```

### Commit Messages

```
type(scope): short description

Longer description if needed.

Refs: #issue-number
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`

Examples:
- `feat(reflex): add new threat pattern for prompt injection`
- `fix(health): correct composite score calculation`
- `docs(volume-iii): clarify continuity framework`
- `test(spawn): add edge case for lineage depth`

---

## Review Process

### What We Look For

1. **Correctness**: Does the change work as intended?
2. **Safety**: Does it maintain EFM safety properties?
3. **Clarity**: Is the code/documentation clear?
4. **Testing**: Are there adequate tests?
5. **Documentation**: Is the change documented?

### Timeline

- Initial review: 1-2 weeks
- Follow-up reviews: 3-5 days
- Merge after approval: 1-2 days

### Feedback

All feedback will be:
- Constructive and specific
- Focused on the contribution, not the contributor
- Aimed at improving the project

---

## Getting Help

If you need help:

1. Check existing documentation
2. Search closed issues
3. Open a new issue with:
   - Clear description of the problem
   - Steps to reproduce (if applicable)
   - What you've already tried

---

## Recognition

All contributors will be:
- Listed in CONTRIBUTORS.md
- Acknowledged in release notes
- Credited in relevant documentation

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (CC BY 4.0 for documentation, MIT for code).

---

## Questions?

Open an issue or reach out to the maintainers.

**Thank you for helping make EFM better!**

---

*Entropica SPC — Yology Research Division*
