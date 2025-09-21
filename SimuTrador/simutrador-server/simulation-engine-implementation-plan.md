# SimuTrador Simulation Engine Implementation Plan

## 📋 **Executive Summary**

This document outlines a systematic implementation plan for the SimuTrador WebSocket API v2.0 simulation engine. The plan breaks down the complex WebSocket-based trading simulation system into manageable development phases, with each functionality implemented in the smallest possible steps on both server and client sides.

## ✅ Status Update (current)

- Authentication: Implemented (JWT over REST + WebSocket auth). 429 Too Many Requests with Retry-After for rate-limited handshakes.
- Connection caps: Enforced and advertised from a single config source (RateLimitConfig.ws_max_connections_by_plan).
- Pre-auth WS limiter: Active per-IP token bucket applied before auth (separate from plan caps).
- Session management (v1): Implemented. In-memory SessionManager with creation on start_simulation, validation, and automatic cleanup on close.
- Integration tests: Auth flow, WS handshake denials (429), and basic session lifecycle are covered.

## 📊 Progress and Roadmap (condensed)

- Phase 1: Foundation & Authentication — Completed
- Phase 2: Session Management — In progress (v1 implemented server-side)
- Phases 3–8: Pending (see roadmap below)
- Phase 9: Production Authentication — Planned

| Phase                    | Scope (high level)                                                                                           | Status                            |
| ------------------------ | ------------------------------------------------------------------------------------------------------------ | --------------------------------- |
| 1\. Foundation & Auth    | JWT service, /auth/token (mock for dev), WS auth, connection caps via config, 429 on rate-limited handshakes | Completed                         |
| 2\. Session Management   | In‑memory SessionManager; create/validate; v1 uses start_simulation to create; cleanup on close              | In progress (v1 done server‑side) |
| 3\. Basic Simulation     | Tick generator, flow control, simulation state                                                               | Pending                           |
| 4\. Order Management     | Validation, storage, batch processing                                                                        | Pending                           |
| 5\. Execution Engine     | Market data loader, fills, commissions, reports                                                              | Pending                           |
| 6\. Portfolio Management | Positions, snapshots, performance metrics                                                                    | Pending                           |
| 7\. Advanced             | Pause/resume, reconnection, message‑level rate limits                                                        | Pending                           |
| 8\. Production Readiness | Monitoring, optimization, logging                                                                            | Pending                           |
| 9\. Production Auth      | Real user management, API keys, DB, security                                                                 | Planned                           |

### Execution tracker (authoritative)

- Authentication
  - JWT auth implemented; CLI login/status/logout
  - WS handshake denial returns 429 with Retry-After when rate-limited
- WebSocket + Health
  - connection_ready advertises plan cap from single config source
  - Pre-auth IP WS limiter (429 + Retry-After) active
  - Standardize health/handshake headers (X-RateLimit-\*, Retry-After) consistently
- Rate limiting
  - Single source of truth for per-plan concurrent WS caps
  - Message-level limits: finalize policy + consistent error format
  - Make Retry-After for plan caps configurable (not hardcoded "5")
- Sessions
  - SessionManager v1 (in-memory), create on start_simulation, auto-cleanup
  - Expose create_session/list/close handlers; enforce per-user session caps
- Client SDK/CLI
  - WebSocket client abstraction + persistent connection
  - CLI simulate/session subcommands (start, list, close)
- Testing/Docs
  - WS auth + 429 handshake tests (server)
  - Rate-limiting integration tests (client)
  - Demo-as-test for connection caps vs pre-auth limiter; troubleshooting note

### 🔐 Rate Limiting (single config source)

- Plan caps are read from one place: RateLimitConfig.ws_max_connections_by_plan (e.g., FREE=2)
- Enforcement and the advertised concurrent_connections_limit both use this config
- Pre‑auth WebSocket IP limiter runs before plan checks; on exhaustion it rejects the handshake with HTTP 429 and Retry‑After
- Plan cap rejections also return HTTP 429; clients can distinguish using context/logs

### 🧩 Session Management v1 snapshot

- Storage: In‑memory SessionManager
- Lifecycle: Created on start_simulation; validated; cleaned up on close/disconnect
- Next: Add explicit create_session message, client-side session commands, and stronger validation against market data

## 🎯 **Current State Analysis**

### ✅ **What Exists**

- **Core Models**: Complete Pydantic models in `simutrador-core` for WebSocket communication
- **Server**: FastAPI WebSocket server with JWT auth, 429 handshake denials with Retry-After, and connection caps
- **Client**: CLI auth flow; WS flows exercised in integration tests; no SDK WebSocket abstraction/CLI simulate/session yet
- **Session Management (v1)**: In-memory SessionManager; creation on `start_simulation`, validation, and cleanup on close
- **Rate Limiting (config-driven)**: Plan-based concurrent connection caps sourced from a single config; pre-auth IP limiter active
- **Testing Infrastructure**: Unit + integration tests including auth, WS handshake denials, and session lifecycle
- **Documentation**: Complete API specification in `ws_api_v2.md`

### 🔄 **What Needs Implementation**

- **Simulation Engine**: Core tick-by-tick execution with order processing
- **Market Data Integration**: Historical data loading and validation
- **Order Execution**: Realistic fill simulation with slippage and commissions
- **Portfolio Management**: Account state tracking and performance metrics
- **Error Handling**: Comprehensive error recovery and reconnection logic
- **Rate Limiting (message-level)**: Burst/throughput limits and consistent headers across endpoints

## 🏗️ **Implementation Strategy**

### **Development Principles**

1.  **Incremental Development**: Each feature implemented in 20-minute development chunks
2.  **Test-Driven Development**: Write tests before implementation
3.  **Dual-Side Implementation**: Server and client developed in parallel
4.  **CLI Integration**: Every feature accessible via command-line interface
5.  **Integration Testing**: End-to-end tests for each complete workflow

### **Quality Gates**

- All code must pass type checking (pyright)
- All tests must pass before moving to next phase
- Integration tests must verify server-client communication
- CLI commands must be documented and tested

## 📊 **Implementation Phases**

### **Phase 1: Foundation & Authentication** (Estimated: 8-10 tasks)

**Goal**: Establish secure WebSocket connections with JWT authentication

#### **Server Tasks**

1.  **JWT Token Service**: Implement token generation and validation
2.  **REST Auth Endpoint**: Create `/auth/token` endpoint for API key exchange
3.  **WebSocket Authentication**: Add JWT validation to WebSocket connections
4.  **Connection Management**: Implement connection limits and timeouts

#### **Client Tasks**

1.  **Authentication Client**: Add JWT token exchange to client SDK
2.  **WebSocket Connection**: Implement authenticated WebSocket connection
3.  **CLI Auth Commands**: Add authentication commands to CLI
4.  **Integration Tests**: Test complete authentication flow

### **Phase 2: Session Management** (Estimated: 6-8 tasks)

**Goal**: Create and manage simulation sessions with market data validation

#### **Server Tasks**

1.  **Session Storage**: Implement in-memory session management
2.  **Market Data Validation**: Validate symbols and date ranges
3.  **Session Creation Handler**: Process `create_session` messages

#### **Client Tasks**

1.  **Session Client**: Add session creation to client SDK
2.  **CLI Session Commands**: Add session management to CLI
3.  **Integration Tests**: Test session creation and validation

### **Phase 3: Basic Simulation Engine** (Estimated: 10-12 tasks)

**Goal**: Implement tick-by-tick simulation with flow control

#### **Server Tasks**

1.  **Tick Generator**: Create time-based tick generation
2.  **Flow Control**: Implement tick acknowledgment system
3.  **Simulation State**: Track simulation progress and state

#### **Client Tasks**

1.  **Tick Handler**: Process tick messages and send acknowledgments
2.  **CLI Simulation Commands**: Add simulation control to CLI
3.  **Integration Tests**: Test basic simulation flow

### **Phase 4: Order Management** (Estimated: 8-10 tasks)

**Goal**: Process and validate trading orders

#### **Server Tasks**

1.  **Order Validation**: Validate order parameters and constraints
2.  **Order Storage**: Manage pending and executed orders
3.  **Batch Processing**: Handle order batch messages

#### **Client Tasks**

1.  **Order Client**: Add order submission to client SDK
2.  **CLI Order Commands**: Add order management to CLI
3.  **Integration Tests**: Test order submission and validation

### **Phase 5: Execution Engine** (Estimated: 12-15 tasks)

**Goal**: Implement realistic order execution with market data

#### **Server Tasks**

1.  **Market Data Loader**: Load historical OHLCV data for simulation
2.  **Fill Engine**: Implement realistic order fills with slippage
3.  **Commission Calculator**: Apply commission and fee calculations
4.  **Execution Reports**: Generate detailed execution reports

#### **Client Tasks**

1.  **Execution Handler**: Process execution reports
2.  **CLI Execution Commands**: Add execution monitoring to CLI
3.  **Integration Tests**: Test order execution and fills

### **Phase 6: Portfolio Management** (Estimated: 8-10 tasks)

**Goal**: Track account state and calculate performance metrics

#### **Server Tasks**

1.  **Position Tracking**: Maintain current positions and cash balance
2.  **Account Snapshots**: Generate real-time account updates
3.  **Performance Metrics**: Calculate PnL, drawdown, and ratios

#### **Client Tasks**

1.  **Portfolio Client**: Handle account snapshot updates
2.  **CLI Portfolio Commands**: Add portfolio monitoring to CLI
3.  **Integration Tests**: Test portfolio tracking and metrics

### **Phase 7: Advanced Features** (Estimated: 10-12 tasks)

**Goal**: Implement interactive control and error recovery

#### **Server Tasks**

1.  **Simulation Control**: Pause, resume, and query simulation state
2.  **Session Recovery**: Handle disconnection and reconnection
3.  **Rate Limiting**: Implement user plan-based limits

#### **Client Tasks**

1.  **Interactive Control**: Add simulation control to client SDK
2.  **Reconnection Logic**: Implement automatic reconnection
3.  **CLI Advanced Commands**: Add advanced control features
4.  **Integration Tests**: Test interactive features and recovery

### **Phase 8: Production Readiness** (Estimated: 6-8 tasks)

**Goal**: Prepare system for production deployment

#### **Server Tasks**

1.  **Connection Monitoring**: Implement connection warnings and cleanup
2.  **Performance Optimization**: Optimize for concurrent sessions
3.  **Logging and Monitoring**: Add comprehensive logging

#### **Client Tasks**

1.  **Error Handling**: Implement robust error handling
2.  **CLI Documentation**: Complete CLI help and examples
3.  **End-to-End Tests**: Comprehensive integration test suite

### **Phase 9: Production Authentication System** (Estimated: 12-15 tasks)

**Goal**: Replace mock authentication with full user management system

⚠️ **CRITICAL**: Current authentication is **MOCK ONLY** with hardcoded API keys

#### **Server Tasks**

1.  **User Database Schema**: Design and implement user data models
2.  **User Registration API**: Implement user signup and email verification
3.  **API Key Management**: Generate, store, and rotate API keys securely
4.  **User Profile Management**: Update user info, plan changes, billing
5.  **Admin Dashboard API**: User management and analytics endpoints
6.  **Database Integration**: PostgreSQL/MongoDB setup with migrations
7.  **Security Features**: Rate limiting, account lockout, 2FA support
8.  **Audit Logging**: Track authentication events and API usage

#### **Client Tasks**

1.  **Registration Commands**: Add user signup to CLI
2.  **Profile Management**: User profile and API key management commands
3.  **Security Features**: Support for 2FA and key rotation
4.  **Integration Tests**: Test real authentication flow

#### **Infrastructure Tasks**

1.  **Database Setup**: Production database configuration
2.  **Admin Dashboard**: Web interface for user management
3.  **Monitoring**: Authentication metrics and alerting

## Appendix: Historical breakdown (superseded by Execution tracker)

Note: The following detailed lists are historical. The “Execution tracker (authoritative)” above is the source of truth.

### **Phase 1 Tasks (Foundation & Authentication)**

#### **Task 1: JWT Token Service (Server)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 20 minutes**  
**Description**: Create JWT token generation and validation service  
**Deliverables**: ✅ **ALL COMPLETED**

- ✅ `JWTService` class with token generation and validation
- ✅ Support for user plans and rate limits in JWT payload
- ✅ Token expiration handling (1 hour default)
- ✅ Unit tests for token operations (19 tests, 100% pass rate)

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Create `src/simutrador_server/services/auth/jwt_service.py`
2.  ✅ Implement `generate_token()` and `validate_token()` methods
3.  ✅ Add JWT secret key configuration
4.  ✅ Write unit tests in `tests/unit/test_jwt_service.py`

**Additional Features Implemented**:

- ✅ User context extraction with `extract_user_context()`
- ✅ Token expiry checking with `is_token_expired()`
- ✅ Token expiry time retrieval with `get_token_expiry()`
- ✅ Global service instance management
- ✅ Comprehensive error handling and validation
- ✅ Security features (audience/issuer validation)

**Files Created**:

- ✅ `src/simutrador_server/services/auth/jwt_service.py` (225 lines)
- ✅ `src/simutrador_server/services/auth/__init__.py`
- ✅ `src/simutrador_server/services/__init__.py`
- ✅ `tests/unit/test_jwt_service.py` (300+ lines, 19 test cases)
- ✅ `tests/unit/__init__.py`
- ✅ `tests/__init__.py`

**Dependencies Added**:

- ✅ `pyjwt>=2.8.0` added to pyproject.toml
- ✅ `simutrador-core>=1.0.9` from TestPyPI

---

## Appendix: Historical progress status (superseded by Execution tracker)

Note: The following status is historical and may not reflect current reality. Refer to the Execution tracker above.

### **Phase 1: Foundation & Authentication** (8/8 tasks completed - 100%) ✅ **COMPLETED**

- ✅ **Task 1: JWT Token Service (Server)** - COMPLETED
- ✅ **Task 2: REST Auth Endpoint (Server)** - COMPLETED (MOCK ONLY) ⚠️
- ✅ **Task 3: WebSocket Authentication (Server)** - COMPLETED ✨ **NEW**
- ✅ **Task 4: Connection Management (Server)** - COMPLETED
- ✅ **Task 5: Authentication Client (Client)** - COMPLETED ✨ **NEW**
- ✅ **Task 6: WebSocket Connection (Client)** - COMPLETED ✨ **NEW**
- ✅ **Task 7: CLI Auth Commands (Client)** - COMPLETED
- ✅ **Task 8: Integration Tests (Authentication)** - COMPLETED ✨ **NEW**

⚠️ **IMPORTANT**: Task 2 uses hardcoded API keys for development. Production authentication system required (Phase 9).

✨ **NEW ACHIEVEMENT**: Multi-service server architecture implemented with separate auth (port 8001) and WebSocket (port 8003) servers.

### **Overall Project Status**

- **Total Tasks**: 65+ tasks across 9 phases (added Phase 9: Production Authentication)
- **Completed**: 8 tasks (12.3%) - ⚠️ **1 task is mock implementation only**
- **Mock/Development**: 1 task (Task 2: REST Auth with hardcoded keys)
- **Production Ready**: 7 tasks (JWT Service, WebSocket Auth, Connection Management, Auth Client, WebSocket Connection, CLI Auth Commands, Integration Tests)
- **Pending**: 57+ tasks (87.7%)
- **Estimated Remaining Time**: 15-19 hours (including production auth system)

### **Recent Achievements** ✨

- **🎉 Phase 1 Complete**: Full WebSocket authentication system implemented and tested
- **WebSocket Authentication**: JWT-based authentication with proper error handling and rate limiting
- **Configuration-Based Rate Limiting**: Superior to originally planned approach with clean test integration
- **Comprehensive Testing**: 102 tests (100% passing) including unit, integration, and auth flow tests
- **Production-Ready Architecture**: Clean CI/CD pipeline, type safety, and real-world validation
- **Multi-Service Architecture**: Implemented separate auth (8001) and WebSocket (8003) servers
- **VS Code Integration**: Configured launch configurations for easy development
- **Port Standardization**: Updated client and server configurations for consistent port usage
- **Type Safety**: Resolved all authentication API type checking errors
- **Dependency Updates**: Updated to simutrador-core 1.0.10 with shared authentication models

### **Critical Gap Identified**

⚠️ **Authentication System**: Current implementation uses hardcoded API keys for development only.  
**Production deployment requires Phase 9 completion** (12-15 additional tasks).

### **Next Immediate Steps**

🎉 **Phase 1 Complete!** All authentication tasks finished.

**Ready for Phase 2: Session Management**

1.  **Task 9: Session Storage (Server)** - Implement in-memory session management
2.  **Task 10: Market Data Validation (Server)** - Validate symbols and date ranges
3.  **Task 11: Session Creation Handler (Server)** - Process `create_session` WebSocket messages
4.  **Task 12: Session Client (Client)** - Add session creation to client SDK
5.  **Phase 9 Planning** - Plan production authentication system implementation

### **Technical Achievements Summary** ✨

**Server Architecture Improvements:**

- ✅ **Multi-Service Design**: Separated auth and WebSocket into independent services
- ✅ **Port Standardization**: Auth (8001), WebSocket (8003), consistent across client/server
- ✅ **Environment Configuration**: Flexible settings via .env files and environment variables
- ✅ **Development Integration**: VS Code launch configurations for easy debugging
- ✅ **Type Safety**: Resolved all authentication API type checking errors
- ✅ **Dependency Management**: Updated to simutrador-core 1.0.10 with shared models

**Authentication System Status:**

- ✅ **JWT Service**: Production-ready token generation and validation
- ✅ **REST API**: Mock authentication endpoint for development (`/auth/token`)
- ✅ **Client Integration**: CLI authentication commands working
- ⚠️ **Production Gap**: Real user management system still needed (Phase 9)

**Development Workflow:**

- ✅ **VS Code Integration**: Three launch configurations (Both Servers, Auth Only, WebSocket Only)
- ✅ **Documentation**: Updated all README files and configuration examples
- ✅ **Testing**: Authentication endpoints verified and working

---

#### **Task 2: REST Auth Endpoint (Server)** ✅ **COMPLETED (MOCK ONLY)**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 20 minutes**  
**Description**: Implement `/auth/token` REST endpoint for API key exchange  
**Status**: ✅ **MOCK IMPLEMENTATION COMPLETED** - ⚠️ **PRODUCTION SYSTEM PENDING**

**Mock Implementation Deliverables**: ✅ **ALL COMPLETED**

- ✅ REST endpoint accepting API key in header (`POST /auth/token`)
- ✅ Token response with user information (JWT with user_id, plan)
- ✅ API key validation (hardcoded test keys for development)
- ✅ Integration tests for auth endpoint

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Create `src/simutrador_server/api/auth.py`
2.  ✅ Implement `POST /auth/token` endpoint
3.  ✅ Add mock API key validation logic
4.  ✅ Updated simutrador-core to 1.0.10 for shared auth models

**⚠️ MISSING FOR PRODUCTION: Real User Management System**

The current implementation uses hardcoded API keys for development/testing:

```python
VALID_API_KEYS = {
    "test-api-key-free": {"user_id": "user_free_001", "plan": UserPlan.FREE},
    "test-api-key-pro": {"user_id": "user_pro_001", "plan": UserPlan.PROFESSIONAL},
    "test-api-key-enterprise": {"user_id": "user_ent_001", "plan": UserPlan.ENTERPRISE},
}
```

**Required for Production** (See Phase 9: Production Authentication System):

- User registration and management
- Real API key generation and storage
- Database integration for user data
- API key rotation and security features
- Admin dashboard for user management

#### **Task 3: WebSocket Authentication (Server)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 4.2 hours (including rate limiting)**  
**Description**: Add JWT validation to WebSocket connections  
**Status**: ✅ **COMPLETED** - Full WebSocket authentication system implemented

**Completed Deliverables**: ✅ **ALL COMPLETED + ENHANCEMENTS**

- ✅ WebSocket connection with JWT token validation
- ✅ Connection rejection for invalid tokens with proper error codes
- ✅ User context extraction from JWT
- ✅ WebSocket authentication tests (102 comprehensive tests)
- ✅ **BONUS**: Configuration-based rate limiting system
- ✅ **BONUS**: User plan-based connection limits
- ✅ **BONUS**: Production-ready error handling and logging

**Implementation Steps**: ✅ **ALL COMPLETED + ENHANCEMENTS**

1.  ✅ Implemented complete WebSocket authentication in `src/simutrador_server/websocket_server.py`
2.  ✅ Added JWT token extraction from query parameters
3.  ✅ Implemented connection rejection with proper WebSocket close codes
4.  ✅ Created comprehensive test suite (102 tests, 100% passing)
5.  ✅ **BONUS**: Implemented configuration-based rate limiting system
6.  ✅ **BONUS**: Added user plan-based connection management
7.  ✅ **BONUS**: Created clean CI/CD pipeline with reliable pre-push hooks

#### **Task 4: Connection Management (Server)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 45 minutes**  
**Description**: Implement multi-service server architecture and connection management  
**Status**: ✅ **COMPLETED** - Multi-service architecture implemented

**Completed Deliverables**: ✅ **ARCHITECTURE REDESIGNED AND IMPLEMENTED**

- ✅ Multi-process server architecture (auth + WebSocket services)
- ✅ Environment-based server configuration system
- ✅ VS Code development integration with launch configurations
- ✅ Health check endpoints for service monitoring
- ✅ Port standardization and client configuration updates

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Created `src/simutrador_server/settings.py` - Environment configuration
2.  ✅ Created `src/simutrador_server/auth_server.py` - Standalone auth server (port 8001)
3.  ✅ Created `src/simutrador_server/websocket_server.py` - Standalone WebSocket server (port 8003)
4.  ✅ Updated `src/simutrador_server/main.py` - Multi-process launcher
5.  ✅ Configured VS Code launch.json with 3 development configurations
6.  ✅ Updated client settings and documentation for new port configuration

**Server Architecture Implemented**:

- **Auth Server (8001)**: `/auth/token`, `/auth/validate`, `/health`
- **WebSocket Server (8003)**: `/ws/health`, `/health`, `/ws/simulate` (planned)
- **Multi-process coordination**: Graceful startup/shutdown of both services

#### **Task 5: Authentication Client (Client)**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 25 minutes**  
**Description**: Add JWT token exchange to client SDK  
**Status**: ✅ **COMPLETED** - Full authentication client implemented

**Completed Deliverables**: ✅ **ALL COMPLETED**

- ✅ `AuthClient` class for token exchange
- ✅ API key configuration support with environment variables
- ✅ Token caching and refresh logic
- ✅ Client authentication tests (20 test cases, 100% pass rate)

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Created `src/simutrador_client/auth.py` (200+ lines)
2.  ✅ Implemented token exchange with REST API
3.  ✅ Added token storage and refresh logic
4.  ✅ Wrote comprehensive client authentication tests

#### **Task 6: WebSocket Connection (Client)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 30 minutes**  
**Description**: Implement authenticated WebSocket connection  
**Status**: ✅ **COMPLETED** - Full WebSocket client implemented

**Completed Deliverables**: ✅ **ALL COMPLETED**

- ✅ Authenticated WebSocket connection class
- ✅ JWT token integration with WebSocket URL
- ✅ Connection error handling with proper reconnection logic
- ✅ WebSocket connection tests (integrated with auth flow tests)

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Updated `src/simutrador_client/websocket.py` with authentication
2.  ✅ Added JWT token to WebSocket connection URL
3.  ✅ Implemented comprehensive connection error handling
4.  ✅ Wrote WebSocket connection tests as part of integration suite

#### **Task 7: CLI Auth Commands (Client)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 25 minutes**  
**Description**: Add authentication commands to CLI  
**Deliverables**: ✅ **ALL COMPLETED**

- ✅ `simutrador-client auth login` command
- ✅ `simutrador-client auth status` command
- ✅ `simutrador-client auth logout` command
- ✅ API key configuration via CLI and environment variables
- ✅ CLI authentication tests (19 test cases, 100% pass rate)

**Implementation Steps**: ✅ **ALL COMPLETED**

1.  ✅ Update `src/simutrador_client/cli.py`
2.  ✅ Add authentication subcommands
3.  ✅ Implement API key configuration
4.  ✅ Write CLI authentication tests

**Additional Features Implemented**:

- ✅ Configuration-driven usage (optional CLI arguments)
- ✅ Environment variable support (`AUTH__API_KEY`, `AUTH__SERVER_URL`)
- ✅ Settings integration with precedence system
- ✅ Comprehensive error handling and user guidance
- ✅ Token caching and management
- ✅ WebSocket URL generation with authentication

**Files Created/Modified**:

- ✅ `src/simutrador_client/cli.py` - Added auth commands
- ✅ `src/simutrador_client/auth.py` - Authentication client (200+ lines)
- ✅ `src/simutrador_client/settings.py` - Added auth settings
- ✅ `.env.sample` - Updated with auth configuration
- ✅ `tests/unit/test_auth.py` - Auth client tests (20 tests)
- ✅ `tests/unit/test_cli_auth.py` - CLI auth tests (19 tests)
- ✅ `README.md` - Updated documentation

**Usage Examples**:

```
# Configuration-driven (recommended)
cp .env.sample .env
echo "AUTH__API_KEY=sk_your_key" >> .env
uv run simutrador-client auth login

# Explicit arguments
uv run simutrador-client auth login --api-key sk_key
uv run simutrador-client auth status
uv run simutrador-client auth logout
```

#### **Task 8: Integration Tests (Authentication)** ✅ **COMPLETED**

**Estimated Time**: 20 minutes ✅ **ACTUAL: 2 hours (comprehensive testing)**  
**Description**: Test complete authentication flow end-to-end  
**Status**: ✅ **COMPLETED** - Comprehensive test suite implemented

**Completed Deliverables**: ✅ **ALL COMPLETED + ENHANCEMENTS**

- ✅ End-to-end authentication test (102 comprehensive tests)
- ✅ Server-client authentication integration
- ✅ Error scenario testing (missing tokens, invalid tokens, expired tokens)
- ✅ Authentication flow documentation
- ✅ **BONUS**: Rate limiting functionality tests
- ✅ **BONUS**: Real CLI validation with actual WebSocket connections

**Implementation Steps**: ✅ **ALL COMPLETED + ENHANCEMENTS**

1.  ✅ Created comprehensive test suite across multiple files
2.  ✅ Tested complete authentication workflow with real servers
3.  ✅ Tested all error scenarios and edge cases
4.  ✅ Documented authentication flow in implementation plan
5.  ✅ **BONUS**: Added rate limiting tests and configuration validation
6.  ✅ **BONUS**: Validated real-world CLI usage with WebSocket connections

### **Phase 2 Tasks (Session Management)**

#### **Task 9: Session Storage (Server)**

**Estimated Time**: 20 minutes  
**Description**: Implement in-memory session management  
**Deliverables**:

- `SessionManager` class for session storage
- Session lifecycle management (create, update, cleanup)
- Session state tracking
- Session storage tests

**Implementation Steps**:

1.  Create `src/simutrador_server/services/session_manager.py`
2.  Implement session CRUD operations
3.  Add session state enumeration
4.  Write session storage tests

#### **Task 10: Market Data Validation (Server)**

**Estimated Time**: 20 minutes  
**Description**: Validate symbols and date ranges against available data  
**Deliverables**:

- `MarketDataValidator` class
- Symbol availability checking
- Date range validation
- Data provider integration

**Implementation Steps**:

1.  Create `src/simutrador_server/services/market_data_validator.py`
2.  Implement symbol and date validation
3.  Add data provider availability checks
4.  Write validation tests

#### **Task 11: Session Creation Handler (Server)**

**Estimated Time**: 20 minutes  
**Description**: Process `create_session` WebSocket messages  
**Deliverables**:

- WebSocket message handler for session creation
- Session validation and creation logic
- Error responses for invalid sessions
- Session creation tests

**Implementation Steps**:

1.  Create `src/simutrador_server/websocket/handlers/session_handler.py`
2.  Implement `create_session` message processing
3.  Add session validation and error handling
4.  Write session handler tests

#### **Task 12: Session Client (Client)**

**Estimated Time**: 20 minutes  
**Description**: Add session creation to client SDK  
**Deliverables**:

- `SessionClient` class for session management
- Session creation and validation
- Session state tracking
- Client session tests

**Implementation Steps**:

1.  Create `src/simutrador_client/session.py`
2.  Implement session creation methods
3.  Add session state management
4.  Write client session tests

#### **Task 13: CLI Session Commands (Client)**

**Estimated Time**: 20 minutes  
**Description**: Add session management to CLI  
**Deliverables**:

- `simutrador-client session create` command
- `simutrador-client session status` command
- Session configuration via CLI
- CLI session tests

**Implementation Steps**:

1.  Update `src/simutrador_client/cli.py` with session commands
2.  Add session creation and status commands
3.  Implement session configuration options
4.  Write CLI session tests

#### **Task 14: Integration Tests (Session Management)**

**Estimated Time**: 20 minutes  
**Description**: Test session creation and validation end-to-end  
**Deliverables**:

- End-to-end session creation test
- Session validation error testing
- Multi-symbol session testing
- Session management documentation

**Implementation Steps**:

1.  Create `tests/integration/test_session_flow.py`
2.  Test complete session creation workflow
3.  Test validation errors and edge cases
4.  Document session management flow

### **Phase 3 Tasks (Basic Simulation Engine)**

#### **Task 15: Tick Generator (Server)**

**Estimated Time**: 20 minutes  
**Description**: Create time-based tick generation system  
**Deliverables**:

- `TickGenerator` class for time progression
- Configurable tick intervals
- Market session awareness
- Tick generation tests

**Implementation Steps**:

1.  Create `src/simutrador_server/services/tick_generator.py`
2.  Implement time-based tick generation
3.  Add market session filtering
4.  Write tick generation tests

#### **Task 16: Flow Control (Server)**

**Estimated Time**: 20 minutes  
**Description**: Implement tick acknowledgment system  
**Deliverables**:

- Flow control mechanism for tick processing
- Backpressure handling
- Tick acknowledgment processing
- Flow control tests

**Implementation Steps**:

1.  Create `src/simutrador_server/services/flow_controller.py`
2.  Implement tick acknowledgment system
3.  Add backpressure and queue management
4.  Write flow control tests

#### **Task 17: Simulation State (Server)**

**Estimated Time**: 20 minutes  
**Description**: Track simulation progress and state  
**Deliverables**:

- `SimulationState` class for state management
- Progress tracking and metrics
- State persistence and recovery
- Simulation state tests

**Implementation Steps**:

1.  Create `src/simutrador_server/services/simulation_state.py`
2.  Implement state tracking and persistence
3.  Add progress metrics calculation
4.  Write simulation state tests

#### **Task 18: Tick Handler (Client)**

**Estimated Time**: 20 minutes  
**Description**: Process tick messages and send acknowledgments  
**Deliverables**:

- `TickHandler` class for tick processing
- Automatic tick acknowledgment
- Flow control integration
- Client tick tests

**Implementation Steps**:

1.  Create `src/simutrador_client/tick_handler.py`
2.  Implement tick message processing
3.  Add automatic acknowledgment logic
4.  Write client tick tests

#### **Task 19: CLI Simulation Commands (Client)**

**Estimated Time**: 20 minutes  
**Description**: Add simulation control to CLI  
**Deliverables**:

- `simutrador-client simulate start` command
- `simutrador-client simulate status` command
- Simulation monitoring and control
- CLI simulation tests

**Implementation Steps**:

1.  Update `src/simutrador_client/cli.py` with simulation commands
2.  Add simulation start and control commands
3.  Implement real-time status monitoring
4.  Write CLI simulation tests

#### **Task 20: Integration Tests (Basic Simulation)**

**Estimated Time**: 20 minutes  
**Description**: Test basic simulation flow end-to-end  
**Deliverables**:

- End-to-end simulation test
- Tick flow and acknowledgment testing
- Flow control validation
- Basic simulation documentation

**Implementation Steps**:

1.  Create `tests/integration/test_simulation_flow.py`
2.  Test complete simulation workflow
3.  Test flow control and backpressure
4.  Document basic simulation flow

## 🚀 **Execution Guidelines**

### **Development Workflow**

1.  **Start with Tests**: Write failing tests before implementation
2.  **Implement Incrementally**: Focus on one task at a time
3.  **Validate Continuously**: Run tests after each change
4.  **Document Progress**: Update task status and document learnings

### **Quality Checklist**

- All type hints are present and correct
- Unit tests cover core functionality
- Integration tests verify end-to-end workflows
- CLI commands are documented with help text
- Error handling covers expected failure modes
- Code follows project style guidelines (Ruff, Pyright)

### **Testing Strategy**

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **End-to-End Tests**: Test complete user workflows
- **CLI Tests**: Verify command-line interface functionality

### **Deployment Considerations**

- Use environment variables for configuration
- Implement graceful shutdown handling
- Add health checks for monitoring
- Consider horizontal scaling requirements

## 📊 **Progress Tracking**

### **Phase Completion Criteria**

Each phase is considered complete when:

- All tasks in the phase are implemented
- All tests pass (unit, integration, CLI)
- Documentation is updated
- CLI commands are functional
- Integration tests verify end-to-end functionality

## 🔐 **Phase 9: Production Authentication System - Detailed Tasks**

⚠️ **CRITICAL FOR PRODUCTION**: Replace hardcoded API keys with real user management

### **Database & User Management Tasks**

#### **Task 9.1: User Database Schema**

- Design user table (id, email, password_hash, plan, created_at, etc.)
- API keys table (key_id, user_id, key_hash, permissions, expires_at)
- User sessions table for tracking active sessions
- Database migrations and indexes

#### **Task 9.2: User Registration System**

- `POST /auth/register` endpoint
- Email validation and verification
- Password hashing (bcrypt/argon2)
- Email verification workflow

#### **Task 9.3: API Key Management**

- Generate cryptographically secure API keys
- Store hashed versions in database
- API key rotation and revocation
- Multiple keys per user support

### **Security & Production Tasks**

#### **Task 9.4: Authentication Security**

- Rate limiting per user/IP
- Account lockout after failed attempts
- Password reset workflow
- Two-factor authentication support

#### **Task 9.5: Admin Dashboard**

- User management interface
- API key monitoring and analytics
- Plan upgrades/downgrades
- Usage statistics and billing integration

#### **Task 9.6: Production Infrastructure**

- Database setup (PostgreSQL recommended)
- Redis for session management
- Environment-based configuration
- Monitoring and alerting

**Estimated Total Time for Phase 9**: 4-6 hours of focused development

### **Success Metrics**

- **Code Coverage**: Maintain >90% test coverage
- **Type Safety**: Zero type checking errors
- **Performance**: Handle 1000+ concurrent WebSocket connections
- **Reliability**: 99.9% uptime for simulation sessions
- **Usability**: Complete CLI workflows in \<5 commands
- **Security**: Production-ready authentication with real user management

## 🔄 **Next Steps**

Phase 2: Session Management

1.  Add explicit `create_session` WebSocket message and handler (server)
2.  Client SDK + CLI: `session create` and `session status` commands (client)
3.  Market data validation: symbols/date ranges against provider (server)

Rate limiting

- Keep plan caps in `RateLimitConfig.ws_max_connections_by_plan`
- Consider making pre-auth WS limiter thresholds config-driven
- Ensure consistent `X-RateLimit-*` and `Retry-After` across all 429 responses

Testing

- Integration tests for `create_session` flow
- Tests that distinguish pre-auth 429 (handshake) vs plan-cap 429

Documentation

- Keep demo flags and troubleshooting in sync with current behavior and headers
