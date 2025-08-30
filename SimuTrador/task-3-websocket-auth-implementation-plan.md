# Task 3: WebSocket Authentication Implementation Plan

**Phase 1, Task 3: WebSocket Authentication (Server)**  
**Status**: 🔄 IN PROGRESS  
**Estimated Total Time**: 3.5 hours (210 minutes)  
**Created**: August 30, 2025

## 📋 Overview

This document provides a detailed implementation plan for Task 3 of Phase 1: adding JWT validation to WebSocket connections on the SimuTrador server. This task establishes the security foundation for all WebSocket-based simulation operations.

## 🎯 Main Objective

Add JWT token validation to WebSocket connections, ensuring only authenticated users can establish WebSocket sessions for trading simulations.

## ✅ Prerequisites (Completed)

- **Task 1**: JWT Token Service (Server) - Production-ready token generation/validation
- **Task 2**: REST Auth Endpoint (Server) - Mock authentication endpoint issuing JWT tokens
- **Task 4**: Connection Management (Server) - Multi-service architecture with WebSocket server on port 8003

## 🏗️ Implementation Breakdown

### **Phase 1: Analysis & Design (30 minutes)**

#### **3.1: Analyze Current WebSocket Implementation** (15 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Review existing WebSocket connection handler code
- Identify current connection flow and entry points
- Document existing WebSocket server architecture (port 8003)
- Map integration points for JWT authentication

**Files to Review**:

- `src/simutrador_server/websocket/connection.py`
- `src/simutrador_server/websocket_server.py`
- Current WebSocket endpoint structure

#### **3.2: Design JWT Token Extraction Strategy** (15 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Research WebSocket authentication patterns
- Choose optimal approach (query params vs headers vs subprotocols)
- Design token passing mechanism from client to server
- Plan fallback strategies for different client implementations

**Decision Points**:

- Token source: Query parameters (`?token=jwt`) vs WebSocket headers
- Error handling strategy for missing/invalid tokens
- Connection URL format: `ws://localhost:8003/ws/simulate?token=jwt_token_here`

### **Phase 2: Core Implementation (80 minutes)**

#### **3.3: Implement JWT Token Extraction** (20 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Add code to parse JWT tokens from WebSocket connection requests
- Handle multiple token sources (query parameters, headers)
- Implement token parsing with proper error handling
- Add logging for authentication attempts

**Implementation Details**:

- Extract token from WebSocket query parameters
- Handle URL parsing and token validation
- Add structured logging for security monitoring

#### **3.4: Integrate JWT Validation Service** (20 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Connect WebSocket handler with existing `JWTService`
- Use `validate_token()` and `extract_user_context()` methods
- Handle JWT validation errors and exceptions
- Ensure proper service dependency injection

**Integration Points**:

- Import and use existing `JWTService` from `src/simutrador_server/services/auth/jwt_service.py`
- Handle `JWTError`, `ExpiredSignatureError`, and validation exceptions
- Extract user context: `user_id`, `plan`, `rate_limits`

#### **3.5: Implement User Context Storage** (20 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Store validated user context in WebSocket connection state
- Design connection-scoped user data structure
- Implement user context retrieval for message handlers
- Add user context cleanup on disconnection

**Data Structure**:

```python
class AuthenticatedConnection:
    user_id: str
    user_plan: UserPlan
    rate_limits: Dict[str, int]
    authenticated_at: datetime
    websocket: WebSocket
```

#### **3.6: Add Connection Rejection Logic** (20 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Implement WebSocket close codes for different error types
- Add meaningful error messages for debugging
- Implement graceful connection termination

**Error Codes**:

- `4001`: Authentication required (missing token)
- `4002`: Invalid token
- `4003`: Token expired
- `4000`: Authentication error

### **Phase 3: Testing (70 minutes)**

#### **3.7: Write Unit Tests for Token Validation** (25 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Test JWT token extraction from various sources
- Test integration with JWTService methods
- Test user context storage and retrieval
- Mock WebSocket connection objects for testing

**Test File**: `tests/unit/test_websocket_auth.py`

#### **3.8: Write Integration Tests for WebSocket Auth** (25 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Test end-to-end WebSocket connection with valid tokens
- Test successful authentication and user context extraction
- Test WebSocket message flow with authenticated connections
- Use real WebSocket client for integration testing

**Test File**: `tests/integration/test_websocket_auth_flow.py`

#### **3.9: Test Error Scenarios and Edge Cases** (20 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Test missing token scenarios
- Test malformed/invalid tokens
- Test expired tokens
- Test server errors during validation
- Test connection limits and rate limiting

### **Phase 4: Documentation (30 minutes)**

#### **3.10: Update Documentation and Examples** (15 min)

**Status**: \[ \] NOT STARTED  
**Deliverables**:

- Document WebSocket authentication flow
- Update connection examples with JWT token usage
- Add troubleshooting guide for authentication errors
- Update API documentation with authentication requirements

## 🔧 Technical Implementation Details

### **Authentication Flow**

1.  Client obtains JWT token from REST auth endpoint (`POST /auth/token`)
2.  Client connects to WebSocket with token: `ws://localhost:8003/ws/simulate?token=jwt_token_here`
3.  Server extracts token from query parameters
4.  Server validates token using `JWTService.validate_token()`
5.  If valid: Server extracts user context and allows connection
6.  If invalid: Server rejects connection with appropriate error code

### **Key Files to Modify**

- `src/simutrador_server/websocket/connection.py` - Main WebSocket handler
- `tests/unit/test_websocket_auth.py` - Unit tests
- `tests/integration/test_websocket_auth_flow.py` - Integration tests

### **Dependencies**

- Existing `JWTService` from Task 1
- `simutrador-core` models for authentication
- WebSocket server infrastructure from Task 4

## ✅ Success Criteria

- WebSocket connections require valid JWT tokens
- Invalid tokens are rejected with appropriate error codes (4001, 4002, 4003, 4000)
- User context is extracted and stored for authenticated connections
- All authentication scenarios covered by tests (>95% coverage)
- Integration with existing JWT service works seamlessly
- Documentation updated with authentication flow
- All type checking passes (pyright)
- All tests pass (unit + integration)

## 🔄 Task Dependencies

**Enables Future Tasks**:

- Task 5: Authentication Client (Client)
- Task 6: WebSocket Connection (Client)
- Task 8: Integration Tests (Authentication)

## 📊 Progress Tracking

**Overall Progress**: 0/10 subtasks completed (0%)

**Phase Progress**:

- Analysis & Design: 0/2 tasks (0%)
- Core Implementation: 0/4 tasks (0%)
- Testing: 0/3 tasks (0%)
- Documentation: 0/1 tasks (0%)

## 🚀 Implementation Notes

### **Development Workflow**

1.  Start each subtask by reviewing the deliverables and success criteria
2.  Write failing tests before implementation (TDD approach)
3.  Implement the minimum code to make tests pass
4.  Refactor and optimize while keeping tests green
5.  Update documentation and examples
6.  Mark subtask as complete and move to next

### **Quality Checklist**

- All type hints are present and correct
- Unit tests cover core functionality (>90% coverage)
- Integration tests verify end-to-end workflows
- Error handling covers expected failure modes
- Code follows project style guidelines (Ruff, Pyright)
- Logging is structured and informative
- Security considerations are addressed

### **Testing Strategy**

- **Unit Tests**: Mock WebSocket connections and test authentication logic in isolation
- **Integration Tests**: Use real WebSocket clients to test full authentication flow
- **Error Scenario Tests**: Verify proper handling of all error conditions
- **Performance Tests**: Ensure authentication doesn't significantly impact connection time

---

**Next Step**: Begin with subtask 3.1 - Analyze Current WebSocket Implementation

**Document Status**: ✅ COMPLETE - Ready for implementation
