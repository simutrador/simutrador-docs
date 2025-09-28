# SimuTrador – Complete Trading Simulation Platform

## Overview

**SimuTrador** is a comprehensive trading simulation platform combining robust historical data management with high-fidelity order execution simulation.

It consists of three integrated systems:

1. **OHLCV Data Manager** – fetch, store, and process historical market data
2. **SimuTrador Server** – simulate real-time order execution with realistic market conditions
3. **SimuTrador Client** – Python SDK for server communication

Together, they provide a full solution for **strategy development, backtesting, and validation**.

---

## 🎯 Core Philosophy

Built on **privacy-respecting, realistic simulation**:

- **Keep strategy private** – no code uploads
- **Realistic execution** – slippage, latency, commissions
- **Use your own data** – client manages access, server validates execution
- **One logic for research → production**

### Data Separation Model

```
Client: Strategy logic, data access, order generation
Server: Validation, execution simulation, portfolio tracking
```

---

## 🔒 Key Advantages

- **Privacy & Security** – no strategy exposure, secure JWT auth, isolated runs
- **Execution Fidelity** – realistic fills, bid-ask spreads, partial orders, commissions
- **Developer Experience** – API-first, multiple timeframes, real-time feedback, rich metrics
- **Scalability** – concurrent sims, efficient data, cloud-ready architecture

---

## 🚀 Use Cases

- **Quant Research** – prototyping, optimization, stress testing
- **Algorithm Validation** – slippage analysis, regime testing, scale planning
- **Production Prep** – pre-deployment checks, broker integration, compliance

---

## 💡 Competitive Advantages

- **vs. Backtesting Tools** – no lock-in, no forced frameworks, realistic fills
- **vs. Pro Platforms** – cost-effective, developer-friendly, transparent pricing
- **vs. DIY** – ready-to-use, maintained, scalable, realistic execution

---

## 💸 Pricing Model

| Tier       | Price  | Features                         |
| ---------- | ------ | -------------------------------- |
| Starter    | $29/mo | 10k ticks/day, 3 sims/day        |
| Pro        | $79/mo | 1M ticks/day, unlimited sims     |
| Enterprise | Custom | Unlimited, integrations, support |

**Pay-per-use:**

- $0.01 per 1k ticks
- $0.05 per session report

---

## 📈 Roadmap & Future Vision

**Phase 1 (Dec 2025)** – Python SDK, local sim server, Fidelity L1 fills, basic reports, IBKR comparison  
**Phase 2 (Mar 2026)** – SaaS launch, rate limits, dashboard  
**Phase 3 (Jun 2026)** – Live trading bridge, multi-broker, multi-provider  
**Long-term (2026+)** – Enterprise compliance, global markets, collaborative research, real-time streaming

---

## 🛠️ Technical Implementation

## 🧩 Multi-Repository Structure

```
simutrador/
├── simutrador-core/         # Shared models/utilities (MIT)
├── simutrador-data-manager/ # OHLCV pipeline & APIs (MIT)
├── simutrador-docs/         # Documentation (MIT)
├── simutrador-client/       # Python SDK (MIT)
└── simutrador-server/       # Simulation engine (Private)
```

- [Core](https://github.com/simutrador/simutrador-core) | [Data Manager](https://github.com/simutrador/simutrador-data-manager) | [Docs](https://github.com/simutrador/simutrador-docs) | [Client](https://github.com/simutrador/simutrador-client) | [Server (Private)](https://github.com/simutrador/simutrador-server)

---

## 🏗️ System Architecture

- **Data Layer (OHLCV Manager)** – multi-provider fetch, parquet storage, validation, nightly updates
- **Simulation Layer** – tick-based execution, slippage/fees, portfolio tracking, interactive controls
- **Pipeline** – `Data → Validation → Storage → Resampling → API`
- **Execution Flow** – `Strategy → Orders → Validation → Simulation`

---

## 🔧 Getting Started

1. **Data Setup** – configure sources, run nightly update
2. **Authentication** – exchange API key for JWT
3. **Simulation Setup** – connect via WebSocket and create sessions
4. **Strategy Implementation** – run proprietary logic locally, send orders to server

---

## 📚 Documentation Structure

- **OHLCV Data Manager** – [Overview](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/ohlcv_manager.md), [Nightly Update API](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/nightly%20update.md), [Analysis API](https://github.com/simutrador/simutrador-data-manager/blob/main/docs/data%20analysis.md)
- **WebSocket Simulation API** – [API Spec](https://github.com/simutrador/simutrador-core/blob/main/docs/ws_api_v2.md), auth & lifecycle, order types, real-time protocols

---

## 🤝 Community & Support

- **Docs, SDKs, Example Strategies, Best Practices**
- **Support** – GitHub Issues, Discord, Email, Enterprise Support
- **Contributing** – Open source repos, feature requests, beta testing

---
