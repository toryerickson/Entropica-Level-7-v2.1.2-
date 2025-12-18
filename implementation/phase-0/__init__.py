"""
EFM CODEX - Reference Implementation
=====================================

The Entropica Forensic Model: A Sovereign Organism Framework for Governed AGI

This package provides the Phase 0 reference implementation of the EFM architecture,
including:

- Constitutional context management
- Reflex engine for sub-10ms threat response
- d-CTM forensic audit chain
- Health monitoring
- Spawn governance
- LLM capsule wrapper

Version: 2.0
Author: Entropica SPC - Yology Research Division
License: MIT

Usage:
    from efm import LLMCapsule, DCTM, mock_llm_backend
    
    # Create shared audit chain
    dctm = DCTM()
    
    # Create a governed capsule
    capsule = LLMCapsule(
        llm_backend=mock_llm_backend,  # Replace with real LLM
        task_description="Your task description",
        dctm=dctm
    )
    
    # Process user input through constitutional pipeline
    response, metadata = capsule.process("User input here")
    
    # Spawn child capsules for subtasks
    child = capsule.spawn("Specialized subtask")

For more information, see the EFM Codex documentation.
"""

from .llm_capsule import (
    # Core classes
    LLMCapsule,
    DCTM,
    ReflexEngine,
    HealthMonitor,
    ConstitutionalContext,
    
    # Data classes
    GenesisBlock,
    HealthMetrics,
    DCTMEntry,
    Precedent,
    
    # Enums
    StressLevel,
    HealthStatus,
    DecisionType,
    PriorityTier,
    
    # Constants
    FIVE_COMMANDMENTS,
    SPAWN_CONDITIONS,
    
    # Mock backend for testing
    mock_llm_backend
)

__version__ = "2.0.0"
__author__ = "Entropica SPC, Yology Research Division"
__license__ = "MIT"

__all__ = [
    # Core classes
    "LLMCapsule",
    "DCTM",
    "ReflexEngine",
    "HealthMonitor",
    "ConstitutionalContext",
    
    # Data classes
    "GenesisBlock",
    "HealthMetrics",
    "DCTMEntry",
    "Precedent",
    
    # Enums
    "StressLevel",
    "HealthStatus",
    "DecisionType",
    "PriorityTier",
    
    # Constants
    "FIVE_COMMANDMENTS",
    "SPAWN_CONDITIONS",
    
    # Mock backend
    "mock_llm_backend"
]
