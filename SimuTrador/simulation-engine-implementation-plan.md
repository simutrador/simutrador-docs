# SimuTrador Simulation Engine Implementation Plan

## 📋 **Executive Summary**

This document outlines a systematic implementation plan for the SimuTrador WebSocket API v2.0 simulation engine. The plan breaks down the complex WebSocket-based trading simulation system into manageable development phases, with each functionality implemented in the smallest possible steps on both server and client sides.

## 🎯 **Current State Analysis**

### ✅ **What Exists**

- **Core Models**: Complete Pydantic models in `simutrador-core` for WebSocket communication
- **Basic Server**: Minimal FastAPI server with health check WebSocket endpoint
- **Basic Client**: Simple CLI client with health check functionality and configuration management
- **Testing Infrastructure**: Comprehensive test structure with unit, integration, and paid API tests
- **Documentation**: Complete API specification in `ws_api_v2.md`

### 🔄 **What Needs Implementation**

- **Authentication System**: JWT token exchange and WebSocket authentication
- **Session Management**: Create, validate, and manage simulation sessions
- **Simulation Engine**: Core tick-by-tick execution with order processing
- **Market Data Integration**: Historical data loading and validation
- **Order Execution**: Realistic fill simulation with slippage and commissions
- **Portfolio Management**: Account state tracking and performance metrics
- **Error Handling**: Comprehensive error recovery and reconnection logic
- **Rate Limiting**: User plan-based limits and connection management

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

## 🔧 **Detailed Task Breakdown**

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

## 📊 **Implementation Progress Status**

### **Phase 1: Foundation & Authentication** (3/8 tasks completed - 37.5%)

- ✅ **Task 1: JWT Token Service (Server)** - COMPLETED
- ✅ **Task 2: REST Auth Endpoint (Server)** - COMPLETED (MOCK ONLY) ⚠️
- ⏳ **Task 3: WebSocket Authentication (Server)** - PENDING
- ⏳ **Task 4: Connection Management (Server)** - PENDING
- ⏳ **Task 5: Authentication Client (Client)** - PENDING
- ⏳ **Task 6: WebSocket Connection (Client)** - PENDING
- ✅ **Task 7: CLI Auth Commands (Client)** - COMPLETED
- ⏳ **Task 8: Integration Tests (Authentication)** - PENDING

⚠️ **IMPORTANT**: Task 2 uses hardcoded API keys for development. Production authentication system required (Phase 9).

### **Overall Project Status**

- **Total Tasks**: 65+ tasks across 9 phases (added Phase 9: Production Authentication)
- **Completed**: 3 tasks (4.6%) - ⚠️ **1 task is mock implementation only**
- **Mock/Development**: 1 task (Task 2: REST Auth with hardcoded keys)
- **Production Ready**: 2 tasks (JWT Service, CLI Auth Commands)
- **Pending**: 62+ tasks (95.4%)
- **Estimated Remaining Time**: 20-25 hours (including production auth system)

### **Critical Gap Identified**

⚠️ **Authentication System**: Current implementation uses hardcoded API keys for development only.
**Production deployment requires Phase 9 completion** (12-15 additional tasks).

### **Next Immediate Steps**

1. **Task 3: WebSocket Authentication** - Add JWT validation to WebSocket connections
2. **Task 5: Authentication Client** - Create AuthClient class for token exchange
3. **Task 8: Integration Tests** - Test complete authentication flow
4. **Phase 9 Planning** - Plan production authentication system implementation

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

#### **Task 3: WebSocket Authentication (Server)**

**Estimated Time**: 20 minutes  
**Description**: Add JWT validation to WebSocket connections  
**Deliverables**:

- WebSocket connection with JWT token validation
- Connection rejection for invalid tokens
- User context extraction from JWT
- WebSocket authentication tests

**Implementation Steps**:

1.  Update WebSocket handler in `src/simutrador_server/websocket/connection.py`
2.  Add JWT token extraction from query parameters
3.  Implement connection rejection for invalid tokens
4.  Write WebSocket authentication tests

#### **Task 4: Connection Management (Server)**

**Estimated Time**: 20 minutes  
**Description**: Implement connection limits and timeout handling  
**Deliverables**:

- Connection limit enforcement by user plan
- Idle timeout monitoring
- Connection cleanup on timeout
- Connection management tests

**Implementation Steps**:

1.  Create `src/simutrador_server/services/connection_manager.py`
2.  Implement connection tracking and limits
3.  Add timeout monitoring with background tasks
4.  Write connection management tests

#### **Task 5: Authentication Client (Client)**

**Estimated Time**: 20 minutes  
**Description**: Add JWT token exchange to client SDK  
**Deliverables**:

- `AuthClient` class for token exchange
- API key configuration support
- Token caching and refresh logic
- Client authentication tests

**Implementation Steps**:

1.  Create `src/simutrador_client/auth.py`
2.  Implement token exchange with REST API
3.  Add token storage and refresh logic
4.  Write client authentication tests

#### **Task 6: WebSocket Connection (Client)**

**Estimated Time**: 20 minutes  
**Description**: Implement authenticated WebSocket connection  
**Deliverables**:

- Authenticated WebSocket connection class
- JWT token integration with WebSocket URL
- Connection error handling
- WebSocket connection tests

**Implementation Steps**:

1.  Update `src/simutrador_client/websocket.py`
2.  Add JWT token to WebSocket connection URL
3.  Implement connection error handling
4.  Write WebSocket connection tests

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

```bash
# Configuration-driven (recommended)
cp .env.sample .env
echo "AUTH__API_KEY=sk_your_key" >> .env
uv run simutrador-client auth login

# Explicit arguments
uv run simutrador-client auth login --api-key sk_key
uv run simutrador-client auth status
uv run simutrador-client auth logout
```

#### **Task 8: Integration Tests (Authentication)**

**Estimated Time**: 20 minutes  
**Description**: Test complete authentication flow end-to-end  
**Deliverables**:

- End-to-end authentication test
- Server-client authentication integration
- Error scenario testing
- Authentication flow documentation

**Implementation Steps**:

1.  Create `tests/integration/test_auth_flow.py`
2.  Test complete authentication workflow
3.  Test error scenarios and edge cases
4.  Document authentication flow

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

1.  **Review and Approve Plan**: Stakeholder review of implementation approach
2.  **Set Up Development Environment**: Ensure all tools and dependencies are ready
3.  **Begin Phase 1**: Start with authentication foundation
4.  **Establish CI/CD Pipeline**: Automated testing and deployment
5.  **Monitor Progress**: Regular check-ins and plan adjustments

---

**Total Estimated Development Time**: 50-60 tasks × 20 minutes = 16-20 hours of focused development

This systematic approach ensures that each piece of functionality is thoroughly tested and integrated before moving to the next phase, resulting in a robust and maintainable simulation engine.
