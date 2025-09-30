# SimuTrador

## Complete Trading Simulation Platform

**SimuTrador** is a comprehensive trading simulation platform combining robust historical data management with high-fidelity order execution simulation.

It consists of three integrated systems, the data manager that internally handles the download and update of candles up to 1 minute, the Simulation Server which simulates real-time order execution and market conditions and the Simulation client which provides an SDK for connecting to the server.

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

## 💡 Competitive Advantages

- **vs. Backtesting Tools** – no lock-in, no forced frameworks, realistic fills
- **vs. Pro Platforms** – cost-effective, developer-friendly, transparent pricing
- **vs. DIY** – ready-to-use, maintained, scalable, realistic execution

---

## 🚀 Use Cases

- **Quant Research** – prototyping, optimization, stress testing
- **Algorithm Validation** – slippage analysis, regime testing, scale planning
- **Production Prep** – pre-deployment checks, broker integration, compliance

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

## Reference Table

1. **OHLCV Data Manager** – fetch, store, and process historical market data. Multi-provider fetch, parquet storage, validation, nightly updates
   - [Overview](data-manager/)
   - [Data Management Guide](data-manager/docs/ohlcv_manager.md)
   - [Nightly Update](data-manager/docs/nightly-update.md)
   - [Data Analysis](data-manager/docs/data-analysis.md)
1. **SimuTrador Server** – simulate real-time order execution with realistic market conditions. Tick-based execution, slippage/fees, portfolio tracking, interactive controls
1. **SimuTrador Client** – Python SDK for server communication
