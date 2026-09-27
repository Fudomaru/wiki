#!/usr/bin/env bash

# Purpose: Publish the built site to GitHub Pages via gh-deploy.
# Assumes the virtual environment is in $HOME/.mkdocs-env

set -euo pipefail

# Resolve the repo root from this script's own location, so gh-deploy runs
# against mkdocs.yml no matter where this is called from.
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
WIKI_ROOT="$( realpath "$SCRIPT_PATH/../.." )"

VENV_DIR="$HOME/.mkdocs-env"
MKDOCS_BIN="$VENV_DIR/bin/mkdocs"

if [ ! -x "$MKDOCS_BIN" ]; then
    echo "Error: MkDocs binary not found at $MKDOCS_BIN" >&2
    echo "Please run the bootstrap script to install dependencies." >&2
    exit 1
fi

echo "🌍 Deploying site with mkdocs..."
cd "$WIKI_ROOT"
"$MKDOCS_BIN" gh-deploy
