# APPENDIX B
## Lexicore Runtime: The Semantic Processing Engine

**Version 2.1**  
**EFM Codex**

---

## Overview

The **Lexicore Runtime** is the semantic processing engine that powers capsule cognition. It manages the Lexicon, Ontology, and Embedding spaces that constitute "Cognitive DNA."

**Core Principle:** Meaning is structure. The Lexicore transforms raw input into structured semantic representations.

---

## 1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    LEXICORE RUNTIME                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ LEXICON     │  │ ONTOLOGY    │  │ EMBEDDING           │ │
│  │ MANAGER     │  │ GRAPH       │  │ SPACE               │ │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘ │
│         │                │                     │            │
│         v                v                     v            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SEMANTIC PROCESSOR                      │   │
│  │  - Token resolution                                  │   │
│  │  - Concept binding                                   │   │
│  │  - Meaning synthesis                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         v                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SEMANTIC CACHE                          │   │
│  │  - LRU eviction                                      │   │
│  │  - Coherence validation                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Lexicon Manager

### 2.1 Lexicon Structure

```python
@dataclass
class LexiconEntry:
    """
    A single entry in the Lexicon.
    
    Maps tokens to semantic representations.
    """
    token: str                      # Surface form
    canonical_form: str             # Normalized form
    semantic_type: str              # Noun, verb, concept, etc.
    embedding_id: str               # Link to embedding space
    ontology_nodes: List[str]       # Links to ontology
    frequency: int                  # Usage frequency
    confidence: float               # Confidence in definition
    created_tick: int               # When added
    last_used_tick: int             # Last access
    
    # Relationships
    synonyms: List[str] = field(default_factory=list)
    antonyms: List[str] = field(default_factory=list)
    hypernyms: List[str] = field(default_factory=list)  # Parent concepts
    hyponyms: List[str] = field(default_factory=list)   # Child concepts


class LexiconManager:
    """
    Manages the capsule's vocabulary.
    """
    
    def __init__(self):
        self.entries: Dict[str, LexiconEntry] = {}
        self.canonical_index: Dict[str, str] = {}  # canonical -> token
        self.semantic_index: Dict[str, List[str]] = {}  # type -> tokens
    
    def lookup(self, token: str) -> Optional[LexiconEntry]:
        """
        Look up a token in the lexicon.
        """
        # Direct lookup
        if token in self.entries:
            entry = self.entries[token]
            entry.last_used_tick = current_tick()
            entry.frequency += 1
            return entry
        
        # Try canonical form
        normalized = self._normalize(token)
        if normalized in self.canonical_index:
            return self.lookup(self.canonical_index[normalized])
        
        return None
    
    def add_entry(self, entry: LexiconEntry) -> bool:
        """
        Add a new entry to the lexicon.
        
        Requires coherence check.
        """
        # Check for conflicts
        if entry.token in self.entries:
            return self._handle_conflict(entry)
        
        # Validate entry
        if not self._validate_entry(entry):
            return False
        
        # Add to indices
        self.entries[entry.token] = entry
        self.canonical_index[entry.canonical_form] = entry.token
        
        if entry.semantic_type not in self.semantic_index:
            self.semantic_index[entry.semantic_type] = []
        self.semantic_index[entry.semantic_type].append(entry.token)
        
        # Log
        self.dctm.log("LEXICON_ENTRY_ADDED", "LEXICORE", {
            "token": entry.token,
            "semantic_type": entry.semantic_type
        })
        
        return True
    
    def find_similar(self, token: str, threshold: float = 0.8) -> List[LexiconEntry]:
        """
        Find semantically similar entries.
        """
        entry = self.lookup(token)
        if not entry:
            return []
        
        similar = []
        
        # Check synonyms
        for syn in entry.synonyms:
            if syn in self.entries:
                similar.append(self.entries[syn])
        
        # Check embedding similarity
        if entry.embedding_id:
            similar_embeddings = self.embedding_space.find_similar(
                entry.embedding_id,
                threshold=threshold
            )
            for emb_id in similar_embeddings:
                for e in self.entries.values():
                    if e.embedding_id == emb_id and e.token != token:
                        similar.append(e)
        
        return similar
    
    def _normalize(self, token: str) -> str:
        """
        Normalize token to canonical form.
        """
        return token.lower().strip()
    
    def _validate_entry(self, entry: LexiconEntry) -> bool:
        """
        Validate entry before adding.
        """
        # Must have token
        if not entry.token:
            return False
        
        # Must have semantic type
        if not entry.semantic_type:
            return False
        
        # Confidence must be valid
        if not 0 <= entry.confidence <= 1:
            return False
        
        return True
```

---

## 3. Ontology Graph

### 3.1 Ontology Structure

```python
@dataclass
class OntologyNode:
    """
    A node in the ontology graph.
    
    Represents a concept and its relationships.
    """
    id: str
    name: str
    description: str
    category: str                   # Entity, Action, Property, Relation
    
    # Hierarchical relationships
    parents: List[str] = field(default_factory=list)
    children: List[str] = field(default_factory=list)
    
    # Semantic relationships
    properties: Dict[str, Any] = field(default_factory=dict)
    relations: List['OntologyRelation'] = field(default_factory=list)
    
    # Constraints
    constraints: List['OntologyConstraint'] = field(default_factory=list)


@dataclass
class OntologyRelation:
    """
    A relationship between ontology nodes.
    """
    relation_type: str      # is_a, has_a, part_of, causes, etc.
    target_id: str
    confidence: float
    bidirectional: bool = False


class OntologyGraph:
    """
    The ontology graph representing concept structure.
    """
    
    def __init__(self):
        self.nodes: Dict[str, OntologyNode] = {}
        self.relation_index: Dict[str, List[OntologyRelation]] = {}
    
    def add_node(self, node: OntologyNode) -> bool:
        """
        Add a node to the ontology.
        """
        if node.id in self.nodes:
            return False
        
        self.nodes[node.id] = node
        
        # Update parent-child relationships
        for parent_id in node.parents:
            if parent_id in self.nodes:
                self.nodes[parent_id].children.append(node.id)
        
        # Log
        self.dctm.log("ONTOLOGY_NODE_ADDED", "LEXICORE", {
            "node_id": node.id,
            "category": node.category
        })
        
        return True
    
    def find_path(self, from_id: str, to_id: str) -> Optional[List[str]]:
        """
        Find path between two concepts.
        """
        if from_id not in self.nodes or to_id not in self.nodes:
            return None
        
        # BFS
        queue = [(from_id, [from_id])]
        visited = set()
        
        while queue:
            current, path = queue.pop(0)
            
            if current == to_id:
                return path
            
            if current in visited:
                continue
            visited.add(current)
            
            node = self.nodes[current]
            
            # Check parents and children
            for neighbor in node.parents + node.children:
                if neighbor not in visited:
                    queue.append((neighbor, path + [neighbor]))
            
            # Check relations
            for relation in node.relations:
                if relation.target_id not in visited:
                    queue.append((relation.target_id, path + [relation.target_id]))
        
        return None
    
    def get_ancestors(self, node_id: str) -> List[str]:
        """
        Get all ancestors of a node.
        """
        if node_id not in self.nodes:
            return []
        
        ancestors = []
        queue = list(self.nodes[node_id].parents)
        
        while queue:
            parent_id = queue.pop(0)
            if parent_id not in ancestors:
                ancestors.append(parent_id)
                if parent_id in self.nodes:
                    queue.extend(self.nodes[parent_id].parents)
        
        return ancestors
    
    def get_descendants(self, node_id: str) -> List[str]:
        """
        Get all descendants of a node.
        """
        if node_id not in self.nodes:
            return []
        
        descendants = []
        queue = list(self.nodes[node_id].children)
        
        while queue:
            child_id = queue.pop(0)
            if child_id not in descendants:
                descendants.append(child_id)
                if child_id in self.nodes:
                    queue.extend(self.nodes[child_id].children)
        
        return descendants
    
    def check_constraint(self, node_id: str, action: str) -> bool:
        """
        Check if action satisfies node constraints.
        """
        if node_id not in self.nodes:
            return True
        
        node = self.nodes[node_id]
        
        for constraint in node.constraints:
            if not constraint.evaluate(action):
                return False
        
        return True
```

---

## 4. Embedding Space

### 4.1 Vector Representations

```python
class EmbeddingSpace:
    """
    Vector space for semantic representations.
    """
    
    EMBEDDING_DIM = 768
    
    def __init__(self):
        self.embeddings: Dict[str, np.ndarray] = {}
        self.index = None  # FAISS or similar for fast lookup
    
    def add_embedding(self, id: str, vector: np.ndarray) -> bool:
        """
        Add embedding to the space.
        """
        if vector.shape[0] != self.EMBEDDING_DIM:
            return False
        
        # Normalize
        normalized = vector / (np.linalg.norm(vector) + 1e-8)
        
        self.embeddings[id] = normalized
        self._rebuild_index()
        
        return True
    
    def get_embedding(self, id: str) -> Optional[np.ndarray]:
        """
        Get embedding by ID.
        """
        return self.embeddings.get(id)
    
    def find_similar(self, id: str, k: int = 10, threshold: float = 0.8) -> List[str]:
        """
        Find k most similar embeddings.
        """
        if id not in self.embeddings:
            return []
        
        query = self.embeddings[id]
        
        # Calculate similarities
        similarities = []
        for other_id, other_vec in self.embeddings.items():
            if other_id != id:
                sim = np.dot(query, other_vec)
                if sim >= threshold:
                    similarities.append((other_id, sim))
        
        # Sort by similarity
        similarities.sort(key=lambda x: x[1], reverse=True)
        
        return [s[0] for s in similarities[:k]]
    
    def compute_similarity(self, id1: str, id2: str) -> float:
        """
        Compute cosine similarity between two embeddings.
        """
        if id1 not in self.embeddings or id2 not in self.embeddings:
            return 0.0
        
        return float(np.dot(self.embeddings[id1], self.embeddings[id2]))
    
    def interpolate(self, id1: str, id2: str, alpha: float = 0.5) -> np.ndarray:
        """
        Interpolate between two embeddings.
        """
        if id1 not in self.embeddings or id2 not in self.embeddings:
            return np.zeros(self.EMBEDDING_DIM)
        
        interpolated = alpha * self.embeddings[id1] + (1 - alpha) * self.embeddings[id2]
        return interpolated / (np.linalg.norm(interpolated) + 1e-8)
    
    def _rebuild_index(self):
        """
        Rebuild search index after changes.
        """
        # For production, use FAISS or similar
        pass
```

---

## 5. Semantic Processor

### 5.1 Input Processing

```python
class SemanticProcessor:
    """
    Processes input into semantic representations.
    """
    
    def __init__(self, lexicon: LexiconManager, ontology: OntologyGraph, embeddings: EmbeddingSpace):
        self.lexicon = lexicon
        self.ontology = ontology
        self.embeddings = embeddings
        self.cache = SemanticCache()
    
    def process(self, input_text: str) -> SemanticRepresentation:
        """
        Process input text into semantic representation.
        """
        # Check cache
        cache_key = self._compute_cache_key(input_text)
        cached = self.cache.get(cache_key)
        if cached:
            return cached
        
        # Tokenize
        tokens = self._tokenize(input_text)
        
        # Resolve tokens to lexicon entries
        resolved_tokens = []
        for token in tokens:
            entry = self.lexicon.lookup(token)
            if entry:
                resolved_tokens.append(ResolvedToken(
                    surface=token,
                    entry=entry
                ))
            else:
                # Unknown token - create provisional entry
                resolved_tokens.append(ResolvedToken(
                    surface=token,
                    entry=None,
                    unknown=True
                ))
        
        # Bind to ontology
        bindings = self._bind_to_ontology(resolved_tokens)
        
        # Synthesize meaning
        representation = self._synthesize(resolved_tokens, bindings)
        
        # Cache result
        self.cache.put(cache_key, representation)
        
        return representation
    
    def _tokenize(self, text: str) -> List[str]:
        """
        Tokenize input text.
        """
        # Simple whitespace tokenization
        # Production would use proper NLP tokenizer
        return text.lower().split()
    
    def _bind_to_ontology(self, tokens: List['ResolvedToken']) -> List['OntologyBinding']:
        """
        Bind resolved tokens to ontology nodes.
        """
        bindings = []
        
        for token in tokens:
            if token.entry and token.entry.ontology_nodes:
                for node_id in token.entry.ontology_nodes:
                    if node_id in self.ontology.nodes:
                        bindings.append(OntologyBinding(
                            token=token,
                            node=self.ontology.nodes[node_id],
                            confidence=token.entry.confidence
                        ))
        
        return bindings
    
    def _synthesize(self, 
                   tokens: List['ResolvedToken'],
                   bindings: List['OntologyBinding']) -> SemanticRepresentation:
        """
        Synthesize final semantic representation.
        """
        # Compute aggregate embedding
        embeddings = []
        for token in tokens:
            if token.entry and token.entry.embedding_id:
                emb = self.embeddings.get_embedding(token.entry.embedding_id)
                if emb is not None:
                    embeddings.append(emb)
        
        if embeddings:
            aggregate_embedding = np.mean(embeddings, axis=0)
            aggregate_embedding = aggregate_embedding / (np.linalg.norm(aggregate_embedding) + 1e-8)
        else:
            aggregate_embedding = np.zeros(EmbeddingSpace.EMBEDDING_DIM)
        
        return SemanticRepresentation(
            tokens=tokens,
            bindings=bindings,
            embedding=aggregate_embedding,
            confidence=self._compute_confidence(tokens, bindings)
        )
    
    def _compute_confidence(self, 
                           tokens: List['ResolvedToken'],
                           bindings: List['OntologyBinding']) -> float:
        """
        Compute confidence in semantic representation.
        """
        if not tokens:
            return 0.0
        
        # Factor 1: Token resolution rate
        resolved = sum(1 for t in tokens if not t.unknown)
        resolution_rate = resolved / len(tokens)
        
        # Factor 2: Binding coverage
        bound_tokens = set(b.token for b in bindings)
        binding_rate = len(bound_tokens) / len(tokens) if tokens else 0
        
        # Factor 3: Average entry confidence
        confidences = [t.entry.confidence for t in tokens if t.entry]
        avg_confidence = sum(confidences) / len(confidences) if confidences else 0.5
        
        # Weighted combination
        return (0.4 * resolution_rate + 0.3 * binding_rate + 0.3 * avg_confidence)


@dataclass
class SemanticRepresentation:
    """
    The semantic representation of input.
    """
    tokens: List['ResolvedToken']
    bindings: List['OntologyBinding']
    embedding: np.ndarray
    confidence: float
```

---

## 6. Semantic Cache

```python
class SemanticCache:
    """
    LRU cache for semantic representations.
    """
    
    MAX_SIZE = 10000
    
    def __init__(self):
        self.cache: OrderedDict[str, SemanticRepresentation] = OrderedDict()
    
    def get(self, key: str) -> Optional[SemanticRepresentation]:
        """
        Get from cache, updating LRU order.
        """
        if key in self.cache:
            # Move to end (most recently used)
            self.cache.move_to_end(key)
            return self.cache[key]
        return None
    
    def put(self, key: str, value: SemanticRepresentation):
        """
        Put into cache, evicting if necessary.
        """
        if key in self.cache:
            self.cache.move_to_end(key)
        else:
            if len(self.cache) >= self.MAX_SIZE:
                # Evict oldest
                self.cache.popitem(last=False)
            self.cache[key] = value
    
    def invalidate(self, key: str):
        """
        Invalidate a cache entry.
        """
        if key in self.cache:
            del self.cache[key]
    
    def clear(self):
        """
        Clear entire cache.
        """
        self.cache.clear()
```

---

## 7. Configuration

```yaml
# lexicore_config.yaml
lexicon:
  max_entries: 1000000
  unknown_token_handling: "provisional"
  normalization: "lowercase_strip"

ontology:
  max_nodes: 100000
  max_depth: 20
  constraint_evaluation: true

embedding:
  dimension: 768
  similarity_threshold: 0.8
  index_type: "flat"  # or "ivf" for large scale

cache:
  max_size: 10000
  eviction_policy: "lru"

processing:
  tokenizer: "whitespace"  # or "bpe", "wordpiece"
  batch_size: 32
```

---

## 8. Guarantees

| Property | Guarantee |
|----------|-----------|
| **Token Resolution** | O(1) lookup via hash |
| **Ontology Path** | O(V+E) via BFS |
| **Similarity Search** | O(n) naive, O(log n) with index |
| **Cache Hit** | O(1) |
| **Coherence** | All changes logged |

---

## References

- Volume III: Cognitive DNA
- Appendix J: Constitutional Kernel
- Appendix F: Reflex Escalation

---

*Meaning is structure. Structure is computable.*
