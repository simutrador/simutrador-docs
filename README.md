# SimuTrador Project

🎯 **A comprehensive trading simulation ecosystem built with modern microservices architecture**

This repository contains the complete SimuTrador project, organized as separate repositories for each component.

## 🏗️ Project Structure

```
simutrador/
├── simutrador-core/           # Shared models and utilities
├── simutrador-data-manager/   # Data collection and management
├── simutrador-docs/          # Project documentation (Obsidian vault)
├── simutrador.code-workspace # VS Code multi-repository workspace
└── README.md                 # This file
```

## 📦 Repositories

### [simutrador-core](./simutrador-core/)
**Shared Python package with common models and utilities**
- 🎯 **Purpose**: Shared data models, enums, and utilities
- 🔧 **Tech Stack**: Python 3.11+, Pydantic, Pandas
- 📦 **Distribution**: Published to PyPI
- 🔗 **GitHub**: [simutrador/simutrador-core](https://github.com/simutrador/simutrador-core)

### [simutrador-data-manager](./simutrador-data-manager/)
**Open-source data collection and management system**
- 🎯 **Purpose**: OHLCV data collection, storage, and API
- 🔧 **Tech Stack**: FastAPI (backend), Angular (frontend)
- 🌐 **Features**: Multi-provider data integration, real-time updates
- 🔗 **GitHub**: [simutrador/simutrador-data-manager](https://github.com/simutrador/simutrador-data-manager)

### [simutrador-docs](./simutrador-docs/)
**Centralized project documentation**
- 🎯 **Purpose**: Project-wide documentation and architecture
- 📚 **Format**: Obsidian vault with markdown files
- 🔍 **Features**: Cross-linked documentation, graph view
- 🔗 **GitHub**: [simutrador/simutrador-docs](https://github.com/simutrador/simutrador-docs)

## 🚀 Quick Start

### Option 1: VS Code Workspace (Recommended)
```bash
# Open the multi-repository workspace
code simutrador.code-workspace
```

### Option 2: Individual Repositories
```bash
# Work with specific components
cd simutrador-core        # Core library development
cd simutrador-data-manager # Data management system
cd simutrador-docs        # Documentation (open with Obsidian)
```

## 🛠️ Development Workflow

1. **Core Library Changes**: Work in `simutrador-core/`, publish to PyPI
2. **Data Manager**: Work in `simutrador-data-manager/`, uses published core library
3. **Documentation**: Work in `simutrador-docs/` using Obsidian or any markdown editor

## 📚 Documentation

- **Project Overview**: [simutrador-docs/SimuTrador/main.md](./simutrador-docs/SimuTrador/main.md)
- **Architecture**: [simutrador-docs/SimuTrador/repository-migration-plan.md](./simutrador-docs/SimuTrador/repository-migration-plan.md)
- **WebSocket API**: [simutrador-core/docs/ws_api_v2.md](./simutrador-core/docs/ws_api_v2.md)
- **Data Management**: [simutrador-data-manager/docs/ohlcv_manager.md](./simutrador-data-manager/docs/ohlcv_manager.md)

## 🔧 VS Code Configuration

The workspace is configured for optimal multi-repository development:
- ✅ **Git Integration**: Each repository detected separately
- ✅ **Python Environment**: Configured for simutrador-core development
- ✅ **TypeScript/Angular**: Configured for data-manager frontend
- ✅ **Markdown**: Enhanced editing for documentation

## 🤝 Contributing

Each repository has its own contribution guidelines:
- **simutrador-core**: See [simutrador-core/README.md](./simutrador-core/README.md)
- **simutrador-data-manager**: See [simutrador-data-manager/README.md](./simutrador-data-manager/README.md)
- **simutrador-docs**: See [simutrador-docs/README.md](./simutrador-docs/README.md)

## 📄 License

This project is licensed under the MIT License - see individual repository LICENSE files for details.

---

**🎯 SimuTrador**: Building the future of trading simulation with modern, scalable architecture.
