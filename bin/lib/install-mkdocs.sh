#!/usr/bin/env bash

# Purpose: Create a python virtual environment and install mkdocs.

set -euo pipefail

# Resolve the repo root from this script's own location, so the installer
# works no matter what directory it is invoked from.
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
WIKI_ROOT="$( realpath "$SCRIPT_PATH/../.." )"

VENV_DIR="$HOME/.mkdocs-env"

if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating Python virtual environment at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
else
    echo "Python virtual environment already exists at $VENV_DIR."
fi

echo "Activating virtual environment and installing/upgrading dependencies..."
source "$VENV_DIR/bin/activate"

pip install --upgrade pip
pip install -r "$WIKI_ROOT/requirements.txt"

deactivate

echo "MkDocs installation complete."
