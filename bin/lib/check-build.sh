#!/usr/bin/env bash

# Purpose: Validate that the site builds cleanly in strict mode.
# --strict turns warnings (broken links, bad references) into hard errors,
# so a broken build fails loudly HERE instead of silently shipping.

set -euo pipefail

# Resolve the repo root from this script's own location, so it can be run
# from anywhere and still find mkdocs.yml.
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
WIKI_ROOT="$( realpath "$SCRIPT_PATH/../.." )"

VENV_DIR="$HOME/.mkdocs-env"
MKDOCS_BIN="$VENV_DIR/bin/mkdocs"

if [ ! -x "$MKDOCS_BIN" ]; then
    echo "Error: MkDocs binary not found at $MKDOCS_BIN" >&2
    echo "Please run the bootstrap script to install dependencies." >&2
    exit 1
fi

echo "🔎 Validating site build (strict)..."
cd "$WIKI_ROOT"
"$MKDOCS_BIN" build --strict
echo "✅ Strict build passed."
