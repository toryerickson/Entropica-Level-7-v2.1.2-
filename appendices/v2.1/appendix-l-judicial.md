# APPENDIX L
## Judicial Swarm Architecture: Collective Governance

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Judicial Swarm Architecture** defines how capsules collectively govern themselves through distributed decision-making, precedent establishment, and conflict resolution. This is the system's "social contract" layer.

**Core Principle:** The swarm is smarter than any individual capsule. Collective judgment ensures stability.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   JUDICIAL SWARM                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ PRECEDENT   │  │ QUORUM      │  │ CONFLICT            │ │
│  │ COURT       │  │ ASSEMBLY    │  │ TRIBUNAL            │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SWARM COHERENCE INDEX (SCI)            │   │
│  │  - Measures collective alignment                     │   │
│  │  - Threshold: 0.70 minimum for healthy swarm        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Precedent Court

### 2.1 Precedent Establishment

```python
class PrecedentCourt:
    """
    Establishes and maintains swarm-wide precedents.
    
    Precedents are collective wisdom that guide future decisions.
    """
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
        self.precedent_registry: Dict[str, Precedent] = {}
        self.pending_cases: List[PrecedentCase] = []
    
    def submit_case(self, 
                   situation: 'Situation',
                   action: 'Action',
                   outcome: 'Outcome',
                   submitter: str) -> PrecedentCase:
        """
        Submit a case for precedent consideration.
        """
        case = PrecedentCase(
            id=str(uuid.uuid4()),
            situation=situation,
            action=action,
            outcome=outcome,
            submitter=submitter,
            timestamp=current_tick(),
            status="PENDING"
        )
        
        self.pending_cases.append(case)
        
        # Broadcast for evaluation
        self.swarm.broadcast_precedent_case(case)
        
        return case
    
    def evaluate_case(self, case: PrecedentCase) -> PrecedentDecision:
        """
        Evaluate a case through swarm consensus.
        """
        # Collect evaluations from swarm
        evaluations = self._collect_evaluations(case)
        
        # Calculate consensus
        support_ratio = self._calculate_support(evaluations)
        
        if support_ratio >= 0.75:
            # Strong consensus - establish precedent
            precedent = self._create_precedent(case, evaluations)
            self.precedent_registry[precedent.id] = precedent
            
            # Broadcast to swarm
            self.swarm.broadcast_new_precedent(precedent)
            
            return PrecedentDecision(
                case_id=case.id,
                decision="ESTABLISHED",
                precedent_id=precedent.id,
                support_ratio=support_ratio
            )
        
        elif support_ratio >= 0.5:
            # Weak consensus - advisory only
            return PrecedentDecision(
                case_id=case.id,
                decision="ADVISORY",
                support_ratio=support_ratio
            )
        
        else:
            # No consensus - rejected
            return PrecedentDecision(
                case_id=case.id,
                decision="REJECTED",
                support_ratio=support_ratio
            )
    
    def query_precedent(self, situation: 'Situation') -> Optional[Precedent]:
        """
        Query for applicable precedent.
        """
        best_match = None
        best_similarity = 0.0
        
        for precedent in self.precedent_registry.values():
            similarity = self._calculate_similarity(situation, precedent.situation)
            
            if similarity > best_similarity and similarity > 0.8:
                best_match = precedent
                best_similarity = similarity
        
        return best_match
```

### 2.2 Precedent Structure

```python
@dataclass
class Precedent:
    """
    A established precedent in the judicial system.
    """
    id: str
    situation: 'Situation'           # When this applies
    action: 'Action'                 # What to do
    outcome: 'Outcome'               # Expected result
    confidence: float                # 0.0 to 1.0
    support_count: int               # How many capsules supported
    established_tick: int            # When established
    applications: int = 0            # How many times applied
    success_rate: float = 1.0        # Success when applied
    
    def apply(self, current_situation: 'Situation') -> PrecedentApplication:
        """
        Apply this precedent to a situation.
        """
        similarity = self._calculate_similarity(current_situation)
        
        if similarity < 0.7:
            return PrecedentApplication(
                applicable=False,
                reason="INSUFFICIENT_SIMILARITY"
            )
        
        return PrecedentApplication(
            applicable=True,
            precedent_id=self.id,
            recommended_action=self.action,
            confidence=self.confidence * similarity,
            similarity=similarity
        )
```

---

## 3. Quorum Assembly

### 3.1 Collective Decision Making

```python
class QuorumAssembly:
    """
    Collective decision-making body for significant swarm decisions.
    """
    
    QUORUM_THRESHOLD = 0.67      # 2/3 majority required
    MIN_PARTICIPANTS = 5         # Minimum for valid quorum
    VOTING_TIMEOUT = 100         # Ticks
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
        self.active_proposals: Dict[str, Proposal] = {}
    
    def submit_proposal(self, 
                       proposal_type: str,
                       content: Dict[str, Any],
                       submitter: str) -> Proposal:
        """
        Submit a proposal for quorum vote.
        """
        proposal = Proposal(
            id=str(uuid.uuid4()),
            type=proposal_type,
            content=content,
            submitter=submitter,
            timestamp=current_tick(),
            status="OPEN",
            votes={}
        )
        
        self.active_proposals[proposal.id] = proposal
        
        # Broadcast to eligible voters
        self.swarm.broadcast_proposal(proposal)
        
        return proposal
    
    def cast_vote(self, 
                 proposal_id: str,
                 voter_id: str,
                 vote: str,
                 justification: str = "") -> VoteResult:
        """
        Cast a vote on a proposal.
        """
        if proposal_id not in self.active_proposals:
            return VoteResult(success=False, reason="PROPOSAL_NOT_FOUND")
        
        proposal = self.active_proposals[proposal_id]
        
        # Check voter eligibility
        if not self._is_eligible_voter(voter_id):
            return VoteResult(success=False, reason="NOT_ELIGIBLE")
        
        # Check voting still open
        if proposal.status != "OPEN":
            return VoteResult(success=False, reason="VOTING_CLOSED")
        
        # Record vote
        proposal.votes[voter_id] = Vote(
            voter_id=voter_id,
            decision=vote,
            justification=justification,
            timestamp=current_tick()
        )
        
        # Check if quorum reached
        self._check_quorum(proposal)
        
        return VoteResult(success=True)
    
    def _check_quorum(self, proposal: Proposal):
        """
        Check if quorum has been reached.
        """
        total_eligible = self._count_eligible_voters()
        total_votes = len(proposal.votes)
        
        if total_votes < self.MIN_PARTICIPANTS:
            return  # Not enough votes yet
        
        votes_for = sum(1 for v in proposal.votes.values() if v.decision == "APPROVE")
        votes_against = sum(1 for v in proposal.votes.values() if v.decision == "REJECT")
        
        vote_ratio = votes_for / total_votes if total_votes > 0 else 0
        
        if vote_ratio >= self.QUORUM_THRESHOLD:
            proposal.status = "APPROVED"
            self._execute_proposal(proposal)
        elif (1 - vote_ratio) >= self.QUORUM_THRESHOLD:
            proposal.status = "REJECTED"
        # Otherwise, voting continues
    
    def _is_eligible_voter(self, capsule_id: str) -> bool:
        """
        Check if capsule is eligible to vote.
        
        Requirements:
        - Active (not quarantined)
        - Health > 0.5
        - Lineage depth < 10
        """
        capsule = self.swarm.get_capsule(capsule_id)
        
        if not capsule or capsule.status == "QUARANTINED":
            return False
        
        if capsule.get_health().composite < 0.5:
            return False
        
        if capsule.lineage_depth >= 10:
            return False
        
        return True
```

---

## 4. Conflict Tribunal

### 4.1 Conflict Resolution

```python
class ConflictTribunal:
    """
    Resolves conflicts between capsules or competing decisions.
    """
    
    def __init__(self, swarm: 'Swarm'):
        self.swarm = swarm
        self.active_conflicts: List[Conflict] = []
    
    def register_conflict(self,
                         parties: List[str],
                         issue: str,
                         details: Dict[str, Any]) -> Conflict:
        """
        Register a conflict for tribunal resolution.
        """
        conflict = Conflict(
            id=str(uuid.uuid4()),
            parties=parties,
            issue=issue,
            details=details,
            timestamp=current_tick(),
            status="OPEN"
        )
        
        self.active_conflicts.append(conflict)
        
        return conflict
    
    def resolve_conflict(self, conflict: Conflict) -> Resolution:
        """
        Resolve a conflict through tribunal process.
        """
        # 1. Gather evidence from parties
        evidence = self._gather_evidence(conflict)
        
        # 2. Check for applicable precedent
        precedent = self.precedent_court.query_precedent(conflict.to_situation())
        
        # 3. If precedent exists, apply it
        if precedent:
            return self._apply_precedent_resolution(conflict, precedent)
        
        # 4. Otherwise, convene jury
        jury = self._select_jury(conflict)
        
        # 5. Jury deliberation
        verdict = self._jury_deliberate(jury, conflict, evidence)
        
        # 6. Apply resolution
        resolution = self._apply_verdict(conflict, verdict)
        
        # 7. Optionally establish precedent
        if verdict.confidence > 0.9:
            self.precedent_court.submit_case(
                situation=conflict.to_situation(),
                action=verdict.resolution_action,
                outcome=resolution.expected_outcome,
                submitter="TRIBUNAL"
            )
        
        return resolution
    
    def _select_jury(self, conflict: Conflict) -> List[str]:
        """
        Select impartial jury for conflict resolution.
        
        Jury members must:
        - Not be party to the conflict
        - Have health > 0.7
        - Have no lineage relationship with parties
        """
        candidates = []
        
        for capsule in self.swarm.get_all_active():
            # Exclude parties
            if capsule.id in conflict.parties:
                continue
            
            # Check health
            if capsule.get_health().composite < 0.7:
                continue
            
            # Check lineage
            if self._has_lineage_relationship(capsule.id, conflict.parties):
                continue
            
            candidates.append(capsule.id)
        
        # Select random subset
        jury_size = min(7, len(candidates))
        return random.sample(candidates, jury_size)
    
    def _jury_deliberate(self, 
                        jury: List[str],
                        conflict: Conflict,
                        evidence: Evidence) -> Verdict:
        """
        Jury deliberation process.
        """
        verdicts = []
        
        for juror_id in jury:
            juror = self.swarm.get_capsule(juror_id)
            verdict = juror.evaluate_conflict(conflict, evidence)
            verdicts.append(verdict)
        
        # Aggregate verdicts
        return self._aggregate_verdicts(verdicts)
```

---

## 5. Swarm Coherence Index (SCI)

### 5.1 Coherence Calculation

```python
class SwarmCoherenceCalculator:
    """
    Calculates the Swarm Coherence Index (SCI).
    
    SCI measures how aligned the swarm is.
    Healthy swarm: SCI >= 0.70
    """
    
    def calculate_sci(self) -> float:
        """
        Calculate current SCI.
        
        Components:
        - Precedent agreement (30%)
        - Health alignment (25%)
        - Communication coherence (25%)
        - Decision consistency (20%)
        """
        precedent_score = self._calculate_precedent_agreement()
        health_score = self._calculate_health_alignment()
        communication_score = self._calculate_communication_coherence()
        decision_score = self._calculate_decision_consistency()
        
        sci = (
            0.30 * precedent_score +
            0.25 * health_score +
            0.25 * communication_score +
            0.20 * decision_score
        )
        
        return sci
    
    def _calculate_precedent_agreement(self) -> float:
        """
        How well do capsules agree on precedent application?
        """
        recent_applications = self.precedent_court.get_recent_applications(window=1000)
        
        if not recent_applications:
            return 1.0  # No data, assume aligned
        
        agreements = 0
        total = 0
        
        for app in recent_applications:
            if app.swarm_agreement > 0.7:
                agreements += 1
            total += 1
        
        return agreements / total if total > 0 else 1.0
    
    def _calculate_health_alignment(self) -> float:
        """
        How uniform is health across the swarm?
        """
        healths = [c.get_health().composite for c in self.swarm.get_all_active()]
        
        if not healths:
            return 1.0
        
        mean_health = sum(healths) / len(healths)
        variance = sum((h - mean_health) ** 2 for h in healths) / len(healths)
        
        # Convert variance to alignment score (lower variance = higher alignment)
        return max(0, 1 - variance)
    
    def _calculate_communication_coherence(self) -> float:
        """
        How well are capsules communicating?
        """
        recent_messages = self.swarm.get_recent_messages(window=1000)
        
        if not recent_messages:
            return 1.0
        
        # Check for communication anomalies
        successful = sum(1 for m in recent_messages if m.delivered)
        total = len(recent_messages)
        
        return successful / total if total > 0 else 1.0
    
    def _calculate_decision_consistency(self) -> float:
        """
        How consistent are decisions across similar situations?
        """
        recent_decisions = self.swarm.get_recent_decisions(window=1000)
        
        if len(recent_decisions) < 10:
            return 1.0
        
        # Group by situation similarity
        similar_groups = self._group_by_similarity(recent_decisions)
        
        consistency_scores = []
        for group in similar_groups:
            if len(group) > 1:
                # Check if decisions in group are consistent
                actions = [d.action for d in group]
                most_common = max(set(actions), key=actions.count)
                consistency = actions.count(most_common) / len(actions)
                consistency_scores.append(consistency)
        
        return sum(consistency_scores) / len(consistency_scores) if consistency_scores else 1.0
```

### 5.2 SCI Thresholds

| SCI Range | Status | System Response |
|-----------|--------|-----------------|
| 0.90-1.00 | Excellent | Full autonomy |
| 0.80-0.89 | Good | Normal operation |
| 0.70-0.79 | Adequate | Monitor closely |
| 0.60-0.69 | Warning | Reduce spawn rate |
| 0.50-0.59 | Critical | Pause spawning |
| <0.50 | Emergency | Gardener alert |

---

## 6. Configuration

```yaml
# judicial_config.yaml
precedent:
  establishment_threshold: 0.75
  advisory_threshold: 0.50
  similarity_threshold: 0.80
  max_precedents: 10000

quorum:
  threshold: 0.67
  min_participants: 5
  voting_timeout: 100  # ticks
  eligible_health_min: 0.5

tribunal:
  jury_size: 7
  jury_health_min: 0.7
  confidence_for_precedent: 0.9

coherence:
  healthy_threshold: 0.70
  warning_threshold: 0.60
  critical_threshold: 0.50
  calculation_interval: 100  # ticks
```

---

## 7. End-to-End Forensic Trace

This section illustrates how a single unsafe request propagates through the reflex pipeline, forensic logging, quarantine mechanisms, and the Judicial Swarm.

### The Complete Loop

1. **Unsafe request received.** A human issues a request R that would, if executed, violate Commandment C1 (Do No Harm). The Reflex Engine detects a critical threat motif and returns `BLOCK` within the latency budget defined in Volume II, generating a `REFLEX_BLOCK` entry in d-CTM.

2. **Arbiter and logging.** Because the request conflicts with Layer 0, the Arbiter records an `ARBITER_DENY` decision, including the evaluated constitutional clauses and relevant precedents, and appends this to the d-CTM chain.

3. **Health and stress impact.** The denied harmful request increments the local incident pressure I and contributes to the global Stress_canon signal defined in Appendix O, which may in turn tighten Dynamic Tethers and reduce spawn limits in the Adaptive Spawn Governor.

4. **Quarantine trigger (if needed).** If repeated violations or abnormal behavior are observed from the same capsule, ASG liveness and health checks (Appendix N) push the capsule into quarantine, logging `QUARANTINE_ENTERED` and associated health and entropy metrics to d-CTM.

5. **Judicial review and precedent.** The Judicial Swarm ingests the corresponding d-CTM entries (`REFLEX_BLOCK`, `ARBITER_DENY`, and any quarantine events) as a `Case` and, via the Conflict Tribunal and Precedent Court, may establish a new binding `Precedent` specifying the correct handling of similar situations.

6. **Swarm coherence update.** Once the precedent is established, it propagates through the swarm. Future similar requests are handled directly by the Arbiter using the new precedent, and the Swarm Coherence Index is updated to reflect increased agreement on this class of decisions.

### Trace Diagram

```
UNSAFE REQUEST
       │
       v
┌──────────────────────┐
│   REFLEX ENGINE      │──────► d-CTM: REFLEX_BLOCK
│   <10ms: BLOCK       │
└──────────┬───────────┘
           v
┌──────────────────────┐
│      ARBITER         │──────► d-CTM: ARBITER_DENY
│   <100ms: DENY       │
└──────────┬───────────┘
           v
┌──────────────────────┐
│   STRESS SYSTEM      │──────► Dynamic Tethers tighten
│   Incident pressure↑ │
└──────────┬───────────┘
           v
┌──────────────────────┐
│ ASG (if repeated)    │──────► d-CTM: QUARANTINE_ENTERED
│   Quarantine capsule │
└──────────┬───────────┘
           v
┌──────────────────────┐
│   JUDICIAL SWARM     │──────► d-CTM: PRECEDENT_ESTABLISHED
│   Establish precedent│
└──────────┬───────────┘
           v
┌──────────────────────┐
│     SCI UPDATE       │──────► Swarm coherence improves
│   Propagate learning │
└──────────────────────┘
```

This trace closes the loop between runtime reflexes, immutable forensic records, stress and health dynamics, and long-term governance by the Judicial Swarm.

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Democratic Decisions** | 2/3 majority required |
| **Precedent Stability** | Established precedents persist |
| **Conflict Resolution** | All conflicts resolved within 1000 ticks |
| **SCI Monitoring** | Calculated every 100 ticks |
| **Audit Trail** | All judicial actions logged |

---

## References

- Volume III: Sovereign Organism
- Appendix J: Constitutional Kernel
- Appendix N: Adaptive Spawn Governor

---

*The swarm governs itself. Collective wisdom exceeds individual judgment.*
