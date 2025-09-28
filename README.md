# SimuTrador Docs

[![Docs • Build & Deploy](https://github.com/simutrador/simutrador-docs/actions/workflows/docs.yml/badge.svg)](https://github.com/simutrador/simutrador-docs/actions/workflows/docs.yml)
[![Docs Live](https://img.shields.io/badge/docs-live-brightgreen)](https://simutrador.github.io/simutrador-docs)

This repository hosts the **single source of truth** for SimuTrador documentation.  
We write in **Obsidian** (Markdown), build with **MkDocs + Material**, manage Python deps with **uv**, and publish to **GitHub Pages**.

---

## 🚀 Quick Start (Local)

```bash
# 1) Install deps via uv
uv sync

# 2) Run local docs server with live reload
uv run mkdocs serve
# → http://127.0.0.1:8000
```
