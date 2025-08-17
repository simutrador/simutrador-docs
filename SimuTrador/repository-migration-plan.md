# SimuTrador Repository Migration Plan

## Overview

This document outlines the step-by-step migration plan to restructure the SimuTrador monorepo into a hybrid multi-repo architecture. The migration prioritizes the OHLCV Data Manager extraction first, ensuring it works independently before proceeding with other components.

## Migration Strategy

**Approach**: Hybrid Multi-Repo with Shared Libraries
**Timeline**: 2 weeks (aggressive)
**Priority**: OHLCV Data Manager first (Days 1-7)

## Current Status (as of 2025-08-16)

- simutrador-core package scaffolded and populated with shared models:
  - models: price_data, enums, asset_types, websocket (WS API v2.0)
- Strict typing aligned with backend:
  - pyproject.toml with ruff and dev deps
  - pyrightconfig.json (typeCheckingMode=strict)
  - py.typed included; modern union syntax used (X | None)
- Pre-push git hook in simutrador-core to enforce quality before push:
  - Runs: ruff --fix, pyright, uv build, and import smoke test
- VS Code configured for multi-repo development:
  - .vscode/settings.json updated to detect main repo and simutrador-core
  - simutrador.code-workspace created with both folders
- Build verified: uv build produces wheel and sdist successfully
- Ready to publish to TestPyPI/PyPI

## Target Architecture

```
simutrador-ecosystem/
├── simutrador-core/              # Shared library (Open Source - MIT)
├── simutrador-data-manager/      # OHLCV Manager (Open Source - MIT)
├── simutrador-simulation-server/ # WebSocket Server (Proprietary - Closed)
├── simutrador-client-sdk/        # Client SDKs (Open Source - MIT)
└── simutrador-platform/          # Internal orchestration (Private)
```

## Pre-Migration Checklist

### Current State Validation

- [x] Verify all OHLCV functionality works in current monorepo
- [x] Run full test suite for data management components
- [ ] Document current API endpoints and their dependencies
- [ ] Identify all shared models and utilities
- [ ] Create backup of current repository state

### Environment Setup

- [x] Create GitHub organization: `simutrador`
- [ ] Setup PyPI account for package publishing
- [ ] Configure CI/CD secrets and tokens
- [ ] Prepare development environment with `uv` package manager

## Phase 1: Core Library Extraction (Day 1-2)

### Objective

Extract shared models, utilities, and interfaces into a standalone library that all other components will depend on.

### Step 1.1: Create Core Library Repository (Day 1 - Morning)

```bash
# Create new repository
mkdir simutrador-core
cd simutrador-core
git init
git remote add origin https://github.com/simutrador/simutrador-core.git

# Initialize Python project
uv init --name simutrador-core --lib
```

### Step 1.2: Extract Shared Components (Day 1 - Afternoon)

**Models to Extract (done):**

```bash
# Copied shared models from current backend
cp backend/src/models/price_data.py src/simutrador_core/models/
cp backend/src/models/enums.py src/simutrador_core/models/
cp backend/src/models/asset_types.py src/simutrador_core/models/
# Also created WebSocket models per ws_api_v2 spec
# src/simutrador_core/models/websocket.py
```

Note: We intentionally did NOT move backend-specific models like nightly_update_api.py and responses.py. The Order model lives in simutrador-core via websocket models (client/server batch order flow). Utilities and interfaces will be added as they are identified and stabilized.

**Create Interface Definitions:**

- `src/simutrador_core/interfaces/data_provider.py`
- `src/simutrador_core/interfaces/storage.py`
- `src/simutrador_core/interfaces/validation.py`

### Step 1.3: Setup Core Library Structure (Day 2 - Morning)

**Directory Structure:**

```
simutrador-core/
├── pyproject.toml
├── README.md
├── CHANGELOG.md
├── LICENSE (MIT)
├── src/
│   └── simutrador_core/
│       ├── __init__.py
│       ├── models/
│       │   ├── __init__.py
│       │   ├── price_data.py
│       │   ├── enums.py
│       │   ├── asset_types.py
│       │   └── websocket.py
│       ├── utils/
│       │   ├── __init__.py
│       │   ├── timeframe_utils.py
│       │   ├── validation.py
│       │   └── serialization.py
│       └── interfaces/
│           ├── __init__.py
│           ├── data_provider.py
│           ├── storage.py
│           └── validation.py
├── tests/
│   ├── test_models.py
│   ├── test_utils.py
│   └── test_interfaces.py
└── docs/
    ├── api-reference.md
    └── changelog.md
```

### Step 1.4: Configure Package (Day 2 - Afternoon)

**pyproject.toml (done):**

```toml
[project]
name = "simutrador-core"
version = "1.0.0"
description = "Core models and utilities for SimuTrador trading simulation platform"
readme = "README.md"
license = {text = "MIT"}
authors = [
    {name = "SimuTrador Team", email = "dev@simutrador.com"}
]
requires-python = ">=3.11"
dependencies = [
    "pydantic>=2.11.5",
    "pandas>=2.3.0",
]
keywords = ["trading", "simulation", "finance", "backtesting", "models"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
    "Programming Language :: Python :: 3.13",
    "Topic :: Office/Business :: Financial",
    "Topic :: Software Development :: Libraries :: Python Modules",
    "Typing :: Typed",
]

[project.urls]
Homepage = "https://github.com/simutrador/simutrador-core"
Documentation = "https://docs.simutrador.com/core"
Repository = "https://github.com/simutrador/simutrador-core"
Issues = "https://github.com/simutrador/simutrador-core/issues"
Changelog = "https://github.com/simutrador/simutrador-core/blob/main/CHANGELOG.md"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/simutrador_core"]

[dependency-groups]
dev = [
    "pytest>=8.4.1",
    "pytest-asyncio>=1.0.0",
    "ruff>=0.11.13",
    "pyright>=1.1.0",
    "pandas-stubs>=2.3.0.250703",
]

# Ruff configuration (same as backend)
[tool.ruff]
target-version = "py311"
line-length = 100
src = ["src"]
exclude = ["__pycache__", ".venv", "build", "dist"]

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
ignore = []

[tool.ruff.lint.isort]
known-first-party = ["simutrador_core"]

# Pytest configuration
[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--verbose",
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
]
```

### Step 1.5: Testing and Publishing (Day 3 - Morning)

**Tasks:**

- [x] Test package building: `uv build`
- [x] Add strict pre-push hook in simutrador-core (ruff --fix, pyright, build, import check)
- [ ] Publish to TestPyPI: `uv publish --repository testpypi`
- [ ] Verify installation: `pip install -i https://test.pypi.org/simple/ simutrador-core`
- [ ] Publish to PyPI: `uv publish`
- [ ] Add minimal tests (optional): create tests/ folder and smoke tests for models

### Step 1.6: Update Current Codebase (Day 3 - Afternoon)

**Replace Local Imports:**

```python
# Before (in backend/src/)
from models.price_data import PriceCandle, Timeframe
from models.enums import OrderSide, OrderType
from core.timeframe_utils import get_pandas_frequency

# After
from simutrador_core.models.price_data import PriceCandle, Timeframe
from simutrador_core.models.enums import OrderSide, OrderType
from simutrador_core.utils.timeframe_utils import get_pandas_frequency
```

**Update backend/pyproject.toml:**

```toml
[project]
dependencies = [
    "simutrador-core>=1.0.0,<2.0.0",
    "fastapi[standard]>=0.115.12",
    # ... other existing dependencies
]
```

**Validation Steps:**

- [ ] Update all import statements
- [ ] Remove duplicated code from backend
- [ ] Run full test suite
- [ ] Verify API endpoints still work
- [ ] Test data fetching and storage functionality

## Phase 2: Data Manager Separation (Day 4-7)

### Objective

Extract the complete OHLCV data management system into an independent, open-source repository.

### Step 2.1: Create Data Manager Repository (Day 4 - Morning)

```bash
# Create new repository
mkdir simutrador-data-manager
cd simutrador-data-manager
git init
git remote add origin https://github.com/simutrador/simutrador-data-manager.git

# Initialize Python project
uv init --name simutrador-data-manager
```

### Step 2.2: Extract Data Management Components (Day 4 - Afternoon + Day 5)

**Components to Extract:**

```bash
# API endpoints
cp backend/src/api/trading_data.py src/simutrador_data/api/
cp backend/src/api/nightly_update.py src/simutrador_data/api/
cp backend/src/api/data_analysis.py src/simutrador_data/api/

# Services
cp -r backend/src/services/data_providers/ src/simutrador_data/services/
cp -r backend/src/services/storage/ src/simutrador_data/services/
cp -r backend/src/services/validation/ src/simutrador_data/services/
cp -r backend/src/services/workflows/ src/simutrador_data/services/
cp -r backend/src/services/classification/ src/simutrador_data/services/
cp -r backend/src/services/progress/ src/simutrador_data/services/

# Core utilities
cp backend/src/core/settings.py src/simutrador_data/core/
cp backend/src/core/logger_config.py src/simutrador_data/core/

# Models (data-specific only)
cp backend/src/models/nightly_update_api.py src/simutrador_data/models/
cp backend/src/models/responses.py src/simutrador_data/models/

# Tests
cp -r backend/src/tests/services/ tests/
cp -r backend/src/tests/api/ tests/
cp -r backend/src/tests/e2e/ tests/
```

### Step 2.3: Setup Data Manager Structure (Day 6 - Morning)

**Directory Structure:**

```
simutrador-data-manager/
├── pyproject.toml
├── README.md
├── CHANGELOG.md
├── LICENSE (MIT)
├── docker-compose.yml
├── Dockerfile
├── .env.example
├── src/
│   └── simutrador_data/
│       ├── __init__.py
│       ├── main.py
│       ├── api/
│       │   ├── __init__.py
│       │   ├── trading_data.py
│       │   ├── nightly_update.py
│       │   └── data_analysis.py
│       ├── services/
│       │   ├── __init__.py
│       │   ├── data_providers/
│       │   ├── storage/
│       │   ├── validation/
│       │   ├── workflows/
│       │   ├── classification/
│       │   └── progress/
│       ├── models/
│       │   ├── __init__.py
│       │   ├── nightly_update_api.py
│       │   └── responses.py
│       ├── core/
│       │   ├── __init__.py
│       │   ├── settings.py
│       │   └── logger_config.py
│       └── cli/
│           ├── __init__.py
│           └── commands.py
├── tests/
├── docs/
├── examples/
│   ├── docker-setup/
│   ├── basic-usage/
│   └── kubernetes/
└── storage/
```

### Step 2.4: Configure Data Manager Package (Day 6 - Afternoon)

**pyproject.toml:**

```toml
[project]
name = "simutrador-data-manager"
version = "1.0.0"
description = "OHLCV data management system for trading applications"
readme = "README.md"
license = {text = "MIT"}
authors = [
    {name = "SimuTrador Team", email = "dev@simutrador.com"}
]
requires-python = ">=3.11"
dependencies = [
    "simutrador-core>=1.0.0,<2.0.0",
    "fastapi[standard]>=0.115.12",
    "pandas>=2.3.0",
    "pyarrow>=20.0.0",
    "httpx>=0.28.0",
    "pydantic>=2.11.5",
    "pydantic-settings>=2.7.0",
    "pandas-market-calendars>=4.4.1",
    "uvicorn[standard]>=0.32.1",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.4.1",
    "pytest-asyncio>=1.0.0",
    "ruff>=0.11.13",
    "pyright>=1.1.0",
]

[project.scripts]
simutrador-data = "simutrador_data.cli.commands:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

**Update Import Statements:**

```python
# Update all files to use simutrador-core imports
# Example in src/simutrador_data/api/trading_data.py:

# Before
from models.price_data import PriceCandle, Timeframe
from models.enums import OrderSide

# After
from simutrador_core.models.price_data import PriceCandle, Timeframe
from simutrador_core.models.enums import OrderSide
```

### Step 2.5: Create Standalone FastAPI Application (Day 7 - Morning)

**src/simutrador_data/main.py:**

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from .api import trading_data, nightly_update, data_analysis
from .core.settings import get_settings
from .core.logger_config import setup_logging

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    setup_logging()
    yield
    # Shutdown
    pass

def create_app() -> FastAPI:
    settings = get_settings()

    app = FastAPI(
        title="SimuTrador Data Manager",
        description="OHLCV data management system for trading applications",
        version="1.0.0",
        lifespan=lifespan,
    )

    # CORS middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Include routers
    app.include_router(trading_data.router, prefix="/trading-data", tags=["Trading Data"])
    app.include_router(nightly_update.router, prefix="/nightly-update", tags=["Nightly Update"])
    app.include_router(data_analysis.router, prefix="/data-analysis", tags=["Data Analysis"])

    return app

app = create_app()

if __name__ == "__main__":
    import uvicorn
    settings = get_settings()
    uvicorn.run(
        "simutrador_data.main:app",
        host=settings.api.host,
        port=settings.api.port,
        reload=settings.api.debug,
    )
```

### Step 2.6: Docker Configuration (Day 7 - Afternoon)

**Dockerfile:**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-cache

# Copy application code
COPY . .

# Create storage directory
RUN mkdir -p /app/storage

# Expose port
EXPOSE 8002

# Run the application
CMD ["uv", "run", "python", "-m", "simutrador_data.main"]
```

**docker-compose.yml:**

```yaml
version: "3.8"

services:
  simutrador-data-manager:
    build: .
    ports:
      - "8002:8002"
    environment:
      - API__HOST=0.0.0.0
      - API__PORT=8002
      - API__DEBUG=false
    volumes:
      - ./storage:/app/storage
      - ./environments/.env.prod:/app/.env
    restart: unless-stopped

  # Optional: Add Redis for caching
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    restart: unless-stopped
```

### Step 2.7: Testing and Validation (Day 7 - Evening)

**Validation Checklist:**

- [ ] All API endpoints respond correctly
- [ ] Data fetching from providers works
- [ ] Storage and retrieval functions properly
- [ ] Nightly update workflow completes successfully
- [ ] Data analysis endpoints return correct results
- [ ] Docker container builds and runs
- [ ] All tests pass

**Test Commands:**

```bash
# Run tests
uv run pytest

# Test API endpoints
curl http://localhost:8002/docs
curl http://localhost:8002/trading-data/symbols

# Test Docker build
docker build -t simutrador-data-manager .
docker run -p 8002:8002 simutrador-data-manager
```

## Phase 3: Simulation Server Creation (Week 2)

### Objective

Create the proprietary WebSocket-based trading simulation server.

### Step 3.1: Create Simulation Server Repository (Day 8)

```bash
mkdir simutrador-simulation-server
cd simutrador-simulation-server
git init
# Note: This will be a private repository
git remote add origin https://github.com/simutrador/simutrador-simulation-server.git
```

### Step 3.2: Implement WebSocket Server Structure (Day 9-12)

**Key Components to Implement:**

- JWT authentication system
- WebSocket connection management
- Session lifecycle management
- Order execution engine
- Portfolio tracking
- Performance calculation
- Slippage and commission modeling

### Step 3.3: Integration with Data Manager (Day 13-14)

**Data Integration Strategy:**

- Connect to simutrador-data-manager API for historical data
- Implement data validation and synchronization
- Create market data service interface

## Phase 4: Client SDK Development (Optional - Future)

### Objective

Create open-source client SDKs for easy integration.

**Note**: This can be done later as a separate project once the core system is working.

## Phase 5: Final Integration and Testing (Day 14)

### Step 5.1: End-to-End Testing

**Integration Test Scenarios:**

- Complete data flow from provider to simulation
- WebSocket communication between client and server
- Performance testing under basic load

### Step 5.2: Basic Documentation

**Essential Documentation:**

- README files for each repository
- Basic API documentation
- Docker deployment instructions

## Migration Execution Checklist

### Pre-Migration

- [ ] Backup current repository
- [ ] Create GitHub organization
- [ ] Setup CI/CD infrastructure
- [ ] Prepare PyPI accounts

### Week 1: Core Library + Data Manager (Days 1-7)

- [ ] Day 1-3: Extract shared models and utilities into simutrador-core
- [ ] Day 3: Publish simutrador-core to PyPI
- [ ] Day 3: Update current codebase to use core library
- [ ] Day 4-7: Extract OHLCV management into simutrador-data-manager
- [ ] Day 7: Validate all data operations work independently

### Week 2: Simulation Server (Days 8-14)

- [ ] Day 8: Create simulation server repository
- [ ] Day 9-12: Implement WebSocket server and execution engine
- [ ] Day 13-14: Integration with data manager
- [ ] Day 14: End-to-end testing and basic documentation

### Future (Optional)

- [ ] Client SDK development (Python, JavaScript)
- [ ] Advanced documentation and examples
- [ ] Community adoption and feedback

## Risk Mitigation

### Technical Risks

- **Dependency conflicts**: Use semantic versioning and automated testing
- **Integration failures**: Comprehensive integration test suite
- **Performance degradation**: Benchmark testing at each phase

### Business Risks

- **Service disruption**: Maintain current system until migration complete
- **Customer impact**: Provide migration guides and support
- **Timeline delays**: Prioritize OHLCV manager first (most critical)

## Success Criteria

### Week 1 Success (OHLCV Manager Priority)

- [ ] simutrador-core library published and working
- [ ] simutrador-data-manager runs independently
- [ ] All current OHLCV functionality preserved
- [ ] Docker deployment working
- [ ] API endpoints responding correctly
- [ ] Data fetching and storage operational

### Overall Migration Success

- [ ] All repositories created and functional
- [ ] Different licensing models implemented
- [ ] Independent deployment capabilities
- [ ] Maintained backward compatibility
- [ ] Documentation complete
- [ ] Community adoption of open-source components

## Next Steps

1. **Immediate Action**: Begin Day 1 (Core Library Extraction)
2. **Priority Focus**: Complete Week 1 to ensure OHLCV manager works independently
3. **Validation**: Thoroughly test data management functionality before proceeding to simulation server
4. **Documentation**: Keep this migration plan updated with progress and lessons learned

---

## Quick Start Guide

**Day 1 Morning - Get Started Now:**

```bash
# 1. Create core library
mkdir simutrador-core && cd simutrador-core
uv init --name simutrador-core --lib

# 2. Copy shared models
mkdir -p src/simutrador_core/{models,utils,interfaces}
cp ../backend/src/models/price_data.py src/simutrador_core/models/
cp ../backend/src/models/enums.py src/simutrador_core/models/
cp ../backend/src/core/timeframe_utils.py src/simutrador_core/utils/

# 3. Build and test
uv build
```

**Note**: This aggressive 2-week timeline prioritizes getting the OHLCV Data Manager working independently as quickly as possible. The simulation server can be built once the data foundation is solid.

```

```
