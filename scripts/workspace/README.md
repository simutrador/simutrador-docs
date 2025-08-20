# SimuTrador Workspace Bootstrap

This script helps you set up a local multi-repository workspace for the SimuTrador project.

It will:
- Clone the relevant repositories into a common parent folder
- Ensure the VS Code multi-root workspace (simutrador.code-workspace) includes all repos

## Usage

```bash
# Public repos via HTTPS (default), no private repos
bash scripts/workspace/update_workspace.sh

# Use SSH for remotes
bash scripts/workspace/update_workspace.sh --ssh

# Include private repositories (requires access)
bash scripts/workspace/update_workspace.sh --with-private

# Dry run (print actions, make no changes)
bash scripts/workspace/update_workspace.sh --dry-run

# Force overwrite the simutrador.code-workspace file
bash scripts/workspace/update_workspace.sh --force
```

Notes:
- The script is idempotent and non-destructive by default; it only appends missing entries.
- Use `--force` to overwrite simutrador.code-workspace entirely.
- Private repos require appropriate credentials.

