# SimuTrador - Complete Trading Simulation Platform

- [[#🎯 Core Philosophy|🎯 Core Philosophy]]
  - [[#🎯 Core Philosophy#Data Separation Model|Data Separation Model]]
- [[#🔒 Key Advantages|🔒 Key Advantages]]
  - [[#🔒 Key Advantages#Privacy & Security|Privacy & Security]]
  - [[#🔒 Key Advantages#Execution Fidelity|Execution Fidelity]]
  - [[#🔒 Key Advantages#Developer Experience|Developer Experience]]
  - [[#🔒 Key Advantages#Scalability & Performance|Scalability & Performance]]
- [[#🚀 Use Cases|🚀 Use Cases]]
  - [[#🚀 Use Cases#Quantitative Research|Quantitative Research]]
  - [[#🚀 Use Cases#Algorithm Validation|Algorithm Validation]]
  - [[#🚀 Use Cases#Production Preparation|Production Preparation]]
- [[#💡 Competitive Advantages|💡 Competitive Advantages]]
  - [[#💡 Competitive Advantages#vs. Traditional Backtesting Platforms|vs. Traditional Backtesting Platforms]]
  - [[#💡 Competitive Advantages#vs. Professional Platforms|vs. Professional Platforms]]
  - [[#💡 Competitive Advantages#vs. DIY Solutions|vs. DIY Solutions]]
- [[#💸 Pricing Model|💸 Pricing Model]]
- [[#📈 Roadmap & Future Vision|📈 Roadmap & Future Vision]]
  - [[#📈 Roadmap & Future Vision#Phase 1 - December 2025|Phase 1 - December 2025]]
  - [[#📈 Roadmap & Future Vision#Phase 2 - March 2026 \[Go Live\] 💪|Phase 2 - March 2026 \[Go Live\] 💪]]
  - [[#📈 Roadmap & Future Vision#Phase 3- June 2026|Phase 3- June 2026]]
  - [[#📈 Roadmap & Future Vision#Long-term (2026+)|Long-term (2026+)]]
- [[#🛠️ Technical Implementation|🛠️ Technical Implementation]]
- [[#🧩 Multi-Repository Structure (Mono → Multi Repo)|🧩 Multi-Repository Structure (Mono → Multi Repo)]]
- [[#🏗️ System Architecture|🏗️ System Architecture]]
  - [[#🏗️ System Architecture#Data Management Layer (OHLCV Manager)|Data Management Layer (OHLCV Manager)]]
  - [[#🏗️ System Architecture#Simulation Layer (WebSocket Engine)|Simulation Layer (WebSocket Engine)]]
  - [[#🏗️ System Architecture#Data Pipeline Architecture|Data Pipeline Architecture]]
  - [[#🏗️ System Architecture#Simulation Engine Design|Simulation Engine Design]]
- [[#🔧 Getting Started|🔧 Getting Started]]
  - [[#🔧 Getting Started#1\. Data Setup|1\. Data Setup]]
  - [[#🔧 Getting Started#2\. Authentication|2\. Authentication]]
  - [[#🔧 Getting Started#3\. Simulation Setup|3\. Simulation Setup]]
  - [[#🔧 Getting Started#4\. Strategy Implementation|4\. Strategy Implementation]]
- [[#📚 Documentation Structure|📚 Documentation Structure]]
  - [[#📚 Documentation Structure#OHLCV Data Manager|OHLCV Data Manager]]
  - [[#📚 Documentation Structure#WebSocket Simulation API|WebSocket Simulation API]]
- [[#🤝 Community & Support|🤝 Community & Support]]
  - [[#🤝 Community & Support#Documentation & Resources|Documentation & Resources]]
  - [[#🤝 Community & Support#Support Channels|Support Channels]]
  - [[#🤝 Community & Support#Contributing|Contributing]]
- [[#OHLCV Data Manager|OHLCV Data Manager]]
- [[#WebSocket Simulation API|WebSocket Simulation API]]

## Overview

**SimuTrador** is a comprehensive trading simulation platform that combines robust historical data management with high-fidelity order execution simulation. The platform consists of three integrated systems:

1.  **OHLCV Data Manager** - A sophisticated data pipeline for fetching, storing, and processing historical market data
2.  **Simutrador Server** - A real-time trading simulator that executes orders against historical data with realistic market conditions
3.  **SimuTrador Client** - A python library that is used to handle the communication with the server.

Together, these systems provide developers and quantitative traders with a complete solution for strategy development, backtesting, and validation.

## 🎯 Core Philosophy

SimuTrador is built on the principle of **privacy-respecting, realistic simulation**. Unlike traditional backtesting platforms that require you to upload your strategy code, SimuTrador allows you to:

- **Keep your strategy logic private** - Your proprietary algorithms never leave your environment
- **Test with realistic execution** - Includes slippage, latency, and commissions for accurate results
- **Use your own data** - Client manages market data access while server validates execution
- **Scale from research to production** - Same logic works for backtesting and live trading

### Data Separation Model

```
Client Side:                    Server Side:
- Market data access           - Order validation
- Strategy logic               - Execution simulation
- Order generation             - Portfolio tracking
- Simulation control           - Performance calculation
```

## 🔒 Key Advantages

### Privacy & Security

- **No strategy exposure** - Your trading logic remains completely private
- **Data sovereignty** - You control your market data sources
- **Secure authentication** - JWT-based access with API key management
- **Isolated execution** - Each simulation runs in its own secure context

### Execution Fidelity

- **Realistic fills** - Advanced slippage and latency modeling
- **Market microstructure** - Bid-ask spread simulation and partial fills
- **Commission accuracy** - Configurable fee structures matching real brokers
- **Market hours simulation** - Pre-market, regular, and after-hours sessions

### Developer Experience

- **API-first design** - Integrates seamlessly into CI/CD pipelines
- **Multiple timeframes** - From 1-minute to daily data with automatic resampling
- **Real-time feedback** - Live progress tracking and interactive controls
- **Comprehensive metrics** - Sharpe ratio, drawdown, win rate, and custom analytics

### Scalability & Performance

- **Concurrent simulations** - Run multiple strategies simultaneously
- **Efficient data access** - Columnar storage with intelligent caching
- **Streaming execution** - Memory-efficient processing of large datasets
- **Cloud-ready architecture** - Designed for horizontal scaling

## 🚀 Use Cases

### Quantitative Research

- **Strategy development** - Rapid prototyping and testing of trading ideas
- **Parameter optimization** - Systematic testing of strategy parameters
- **Risk analysis** - Stress testing under different market conditions
- **Performance attribution** - Understanding sources of returns

### Algorithm Validation

- **Backtesting accuracy** - Ensure historical performance matches live execution
- **Slippage analysis** - Understand real-world execution costs
- **Capacity planning** - Test strategy performance at different scales
- **Regime testing** - Validate across different market environments

### Production Preparation

- **Pre-deployment testing** - Final validation before live trading
- **Risk management** - Test stop-loss and position sizing logic
- **Broker integration** - Validate order routing and execution logic
- **Compliance testing** - Ensure adherence to trading rules and limits

## 💡 Competitive Advantages

### vs. Traditional Backtesting Platforms

- **No vendor lock-in** - Use any data source, any programming language
- **No GUI overhead** - Pure API access for programmatic control
- **No forced frameworks** - Integrate with your existing tools and workflows
- **Realistic execution** - More accurate than simple OHLC-based backtests

### vs. Professional Platforms

- **Cost-effective** - Fraction of the cost of enterprise solutions
- **Developer-friendly** - Built for programmers, not point-and-click users
- **Transparent pricing** - No hidden fees or usage-based surprises
- **Open architecture** - Extensible and customizable

### vs. DIY Solutions

- **Production-ready** - Battle-tested execution engine and data pipeline
- **Maintained infrastructure** - No need to build and maintain complex systems
- **Realistic modeling** - Sophisticated slippage and commission simulation
- **Scalable architecture** - Handles large-scale simulations efficiently

## 💸 Pricing Model

SimuTrador offers flexible pricing tiers to accommodate different user needs:

| Tier       | Price     | Features                                                 |
| ---------- | --------- | -------------------------------------------------------- |
| Starter    | $29/month | 10k ticks/day, 3 simulations/day, basic data access      |
| Pro        | $79/month | 1M ticks/day, unlimited simulations, multi-provider data |
| Enterprise | Custom    | Unlimited usage, priority support, custom integrations   |

**Pay-per-use options:**

- `$0.01 per 1000 ticks simulated` - Perfect for occasional testing
- `$0.05 per session` with detailed performance reports

## 📈 Roadmap & Future Vision

### Phase 1 - December 2025

- 🧩 **SDK Development** - Python client library
- **Local server for Stock Trading** - Simulator to support personal strategies
- **Realistic market conditions Fidelity Level 1** - Support realistic market conditions with slippage and spreads, without advanced concepts such as partial fills.
- 📊 **Baktesting Reports Fidelity Level 1**\- Generate useful reports with some important metrics but not advanced analytics
- **Compare Real Strategy results with IBKR paper Trading** - Validate the SaaS by comparing live trading results of any given strategy with the simulation results

### Phase 2 - March 2026 \[Go Live\] 💪

- 🤖 **Rate Limits and Subscriptions** - Implement basic rate limits for free and paid plan, stick only to two plans for simplicity
- 🌐 **SaaS Platform** - Basic Hosted solution with user management goes Live
- 📱 **Dashboard Interface** - Web-based monitoring and control panel

### Phase 3- June 2026

- 📈 **Live Trading Bridge** - Seamless transition from simulation to live trading
- Support multiple data providers
- Support multiple broker integration conditions for slippage and spreads

### Long-term (2026+)

- 🏢 **Enterprise Features** - Multi-tenant architecture and compliance tools
- 🌍 **Global Markets** - Support for international exchanges and instruments
- 🔬 **Research Platform** - Collaborative environment for strategy development
- ⚡ **Real-time Simulation** - Live market simulation with streaming data

## 🛠️ Technical Implementation

## 🧩 Multi-Repository Structure (Mono → Multi Repo)

SimuTrador is organized as a set of focused repositories that work together in a single VS Code workspace.

Project workspace layout:

```
simutrador/ (local workspace folder)
├── simutrador-core/              # Shared Python models & utilities (Open Source - MIT)
├── simutrador-data-manager/      # OHLCV data pipeline and APIs (Open Source - MIT)
├── simutrador-docs/              # Documentation vault (Open Source - MIT)
├── simutrador-client/            # Python client SDK for the WebSocket API (Open Source - MIT)
└── simutrador-server/            # Simulation engine (Private)
```

Repository links:

- Core library: https://github.com/simutrador/simutrador-core
- Data manager: https://github.com/simutrador/simutrador-data-manager
- Documentation: https://github.com/simutrador/simutrador-docs
- Client SDK: https://github.com/simutrador/simutrador-client
- Simulation server (private): https://github.com/simutrador/simutrador-server

Open the multi-repo workspace in VS Code:

```
code simutrador.code-workspace
```

Notes:

- simutrador-core is versioned and consumed by other repos. During development, some repos pull it from TestPyPI until the final PyPI release.
- Each repo uses uv for dependency management, strict type checking with Pyright, Ruff for linting, and pre-push hooks for quality gates.

## 🏗️ System Architecture

### Data Management Layer (OHLCV Manager)

- **Multi-provider data fetching** from Polygon.io, Financial Modeling Prep, and Tiingo
- **Intelligent storage** using partitioned Parquet files for optimal performance
- **Asset-aware resampling** that matches provider aggregation patterns
- **Automated data validation** with gap detection and filling
- **Nightly update workflows** for maintaining current data

### Simulation Layer (WebSocket Engine)

- **Real-time order execution** with tick-by-tick progression
- **Realistic market simulation** including slippage and commission modeling
- **Flow control mechanisms** for managing simulation pace
- **Multi-asset support** with portfolio tracking
- **Interactive controls** for pause/resume and state inspection

### Data Pipeline Architecture

The OHLCV Manager implements a sophisticated data processing pipeline:

```
Data Sources → Validation → Storage → Resampling → API Access
     ↓              ↓          ↓          ↓           ↓
  Polygon.io    Market Cal.  Parquet   Asset-Aware  REST/WS
  FMP/Tiingo    Gap Detection Files    Algorithms   Endpoints
```

### Simulation Engine Design

The WebSocket engine provides real-time execution simulation:

```
Client Strategy → Order Generation → Server Validation → Execution Simulation
       ↓                 ↓                  ↓                    ↓
   Private Logic    Market Orders      Order Validation    Realistic Fills
   Local Data       Limit Orders      Risk Checks         Slippage Model
   Timing Control   Stop Orders       Portfolio Limits    Commission Calc
```

## 🔧 Getting Started

### 1\. Data Setup

First, configure your data sources and begin collecting historical data:

```
# Start the OHLCV Manager
curl -X POST http://localhost:8002/nightly-update/start \
  -H "Content-Type: application/json" \
  -d '{"symbols": ["AAPL", "GOOGL", "MSFT"]}'
```

### 2\. Authentication

Obtain your API credentials and exchange them for a JWT token:

```
# Get JWT token
curl -X POST https://api.simutrador.com/auth/token \
  -H "X-API-Key: sk_live_your_api_key_here"
```

### 3\. Simulation Setup

Connect to the WebSocket API and create your first simulation:

```javascript
const ws = new WebSocket(
  "wss://api.simutrador.com/ws/simulate?token=your_jwt_token"
);

// Create simulation session
ws.send(
  JSON.stringify({
    type: "create_session",
    data: {
      session_id: "my_strategy_test",
      symbols: ["AAPL", "GOOGL"],
      start: "2024-01-01T14:30:00Z",
      end: "2024-01-01T21:00:00Z",
      initial_cash: "100000.00",
    },
  })
);
```

### 4\. Strategy Implementation

Implement your trading logic with full privacy:

```python
# Your strategy logic (runs locally)
def my_strategy(timestamp, market_data):
    # Your proprietary algorithm here
    if should_buy(market_data):
        return create_buy_order("AAPL", 100)
    elif should_sell(market_data):
        return create_sell_order("AAPL", 50)
    return None
```

## 📚 Documentation Structure

This documentation is organized into two main sections:

### OHLCV Data Manager

Comprehensive guide to the data management system (located in [simutrador-data-manager repository](https://github.com/simutrador/simutrador-data-manager)):

- **[OHLCV Manager Overview](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/ohlcv_manager.md)** - System architecture and components
- **[Nightly Update API](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/nightly%20update.md)** - Automated data update workflows
- **[Data Analysis API](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/data%20analysis.md)** - Data completeness and quality analysis
- Data provider integration and configuration
- Storage architecture and optimization
- Validation and quality assurance

### WebSocket Simulation API

Complete reference for the trading simulation engine:

- **[WebSocket API v2.0](./simutrador-server/ws_api_v2.md)** - Complete API specification and examples
- Authentication and connection management
- Session lifecycle and configuration
- Order types and execution modeling
- Real-time communication protocols
- Error handling and recovery

## 🤝 Community & Support

### Documentation & Resources

- **API Documentation** - Complete reference with examples
- **SDK Libraries** - Official clients in multiple languages
- **Example Strategies** - Open-source trading algorithm examples
- **Best Practices** - Guidelines for optimal performance

### Support Channels

- **GitHub Issues** - Bug reports and feature requests
- **Discord Community** - Real-time chat with other developers
- **Email Support** - Direct access to the development team
- **Enterprise Support** - Dedicated support for business customers

### Contributing

SimuTrador is built with the developer community in mind:

- **Open Source Components** - Core libraries available on GitHub
- **API Feedback** - Regular community input on API design
- **Feature Requests** - Community-driven roadmap planning
- **Beta Testing** - Early access to new features

---

## OHLCV Data Manager

!\[\[ohlcv_manager\]\]

## WebSocket Simulation API

!\[\[ws_api_v2\]\]
