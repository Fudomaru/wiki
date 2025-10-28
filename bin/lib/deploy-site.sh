#!/usr/bin/env bash

# Purpose: Deploy the mkdocs site using gh-deploy.
# Assumes the virtual environment is in $HOME/.mkdocs-env

set -euo pipefail

VENV_DIR="$HOME/.mkdocs-env"
MKDOCS_BIN="$VENV_DIR/bin/mkdocs"

if [ ! -x "$MKDOCS_BIN" ]; then
    echo "Error: MkDocs binary not found at $MKDOCS_BIN" >&2
    echo "Please run the bootstrap script to install dependencies." >&2
    exit 1
fi

echo "🌍 Deploying site with mkdocs..."
"$MKDOCS_BIN" gh-deploy
