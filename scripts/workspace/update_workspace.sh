#!/usr/bin/env bash
# Workspace bootstrap for SimuTrador (idempotent & safe by default)
# - Clones missing repositories into a common parent folder
# - Updates simutrador.code-workspace non-destructively (unless --force)
#
# Usage:
#   bash scripts/workspace/update_workspace.sh [--ssh] [--with-private] [--dry-run] [--force]
#
# Flags:
#   --ssh           Use SSH remotes (default is HTTPS for public repos)
#   --with-private  Include private repos (e.g., simulation server) if access is available
#   --dry-run       Print planned actions without making changes
#   --force         Overwrite simutrador.code-workspace instead of append-only update

set -euo pipefail

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
WORKSPACE_ROOT="$(cd "${DOCS_REPO_ROOT}/.." && pwd)"   # parent folder with all repos
WORKSPACE_FILE="${WORKSPACE_ROOT}/simutrador.code-workspace"

USE_SSH=false
WITH_PRIVATE=false
DRY_RUN=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ssh) USE_SSH=true ;;
    --with-private) WITH_PRIVATE=true ;;
    --dry-run) DRY_RUN=true ;;
    --force) FORCE=true ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
  shift
done

# Repo definitions
CORE_DIR="${WORKSPACE_ROOT}/simutrador-core"
DM_DIR="${WORKSPACE_ROOT}/simutrador-data-manager"
DOCS_DIR="${WORKSPACE_ROOT}/simutrador-docs"
CLIENT_DIR="${WORKSPACE_ROOT}/simutrador-client"
SERVER_DIR="${WORKSPACE_ROOT}/simutrador-server"

if [[ "$USE_SSH" == true ]]; then
  REMOTE_CORE="git@github.com:simutrador/simutrador-core.git"
  REMOTE_DM="git@github.com:simutrador/simutrador-data-manager.git"
  REMOTE_DOCS="git@github.com:simutrador/simutrador-docs.git"
  REMOTE_CLIENT="git@github.com:simutrador/simutrador-client.git"
  REMOTE_SERVER="git@github.com:simutrador/simutrador-server.git"
else
  REMOTE_CORE="https://github.com/simutrador/simutrador-core.git"
  REMOTE_DM="https://github.com/simutrador/simutrador-data-manager.git"
  REMOTE_DOCS="https://github.com/simutrador/simutrador-docs.git"
  REMOTE_CLIENT="https://github.com/simutrador/simutrador-client.git"
  REMOTE_SERVER="https://github.com/simutrador/simutrador-server.git"
fi

maybe_clone() {
  local url="$1" dest="$2" name
  name="$(basename "$dest")"
  if [[ -d "$dest/.git" ]]; then
    echo "✅ repo present: $name"
  else
    echo "⬇️  cloning: $name"
    if [[ "$DRY_RUN" == true ]]; then
      echo "(dry-run) git clone $url $dest"
    else
      git clone "$url" "$dest"
    fi
  fi
}

# Clone public repos
maybe_clone "$REMOTE_CORE" "$CORE_DIR"
maybe_clone "$REMOTE_DM" "$DM_DIR"
maybe_clone "$REMOTE_DOCS" "$DOCS_DIR"
maybe_clone "$REMOTE_CLIENT" "$CLIENT_DIR"

# Private repo (optional)
if [[ "$WITH_PRIVATE" == true ]]; then
  maybe_clone "$REMOTE_SERVER" "$SERVER_DIR"
fi

# Update or create the workspace file
append_workspace_folder() {
  local name="$1" path="$2"
  if [[ ! -f "$WORKSPACE_FILE" ]] || [[ "$FORCE" == true ]]; then
    # Create or overwrite workspace file
    local folders='    { "name": "simutrador-core", "path": "simutrador-core" },\n    { "name": "simutrador-data-manager", "path": "simutrador-data-manager" },\n    { "name": "simutrador-docs", "path": "simutrador-docs" },\n    { "name": "simutrador-client", "path": "simutrador-client" }'
    if [[ -d "$SERVER_DIR" ]]; then
      folders+="\n    ,{ \"name\": \"simutrador-server\", \"path\": \"simutrador-server\" }"
    fi
    local json="{\n  \"folders\": [\n${folders}\n  ]\n}"
    if [[ "$DRY_RUN" == true ]]; then
      echo "(dry-run) write $WORKSPACE_FILE"
      echo "$json"
    else
      printf "%s\n" "$json" > "$WORKSPACE_FILE"
      echo "✅ wrote workspace file: $WORKSPACE_FILE"
    fi
    return
  fi

  # Non-destructive update: append only if missing
  if grep -q "\"path\": \"$path\"" "$WORKSPACE_FILE"; then
    echo "✅ workspace already includes: $name"
  else
    echo "➕ adding to workspace: $name"
    if [[ "$DRY_RUN" == true ]]; then
      echo "(dry-run) append $name to $WORKSPACE_FILE"
    else
      # Insert before the closing folders array bracket
      tmp="$(mktemp)"
      awk -v entry="    ,{ \"name\": \"$name\", \"path\": \"$path\" }" '
        BEGIN{added=0}
        /"folders"\s*:\s*\[/ {print; next}
        /^\s*\]/ && added==0 {print entry; print; added=1; next}
        {print}
      ' "$WORKSPACE_FILE" > "$tmp"
      mv "$tmp" "$WORKSPACE_FILE"
      echo "✅ updated workspace: $name"
    fi
  fi
}

append_workspace_folder "simutrador-core" "simutrador-core"
append_workspace_folder "simutrador-data-manager" "simutrador-data-manager"
append_workspace_folder "simutrador-docs" "simutrador-docs"
append_workspace_folder "simutrador-client" "simutrador-client"
if [[ -d "$SERVER_DIR" ]]; then
  append_workspace_folder "simutrador-server" "simutrador-server"
fi

echo "Done. Open workspace with: code \"$WORKSPACE_FILE\""

