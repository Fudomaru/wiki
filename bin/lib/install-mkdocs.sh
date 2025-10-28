#!/usr/bin/env bash

# Purpose: Create a python virtual environment and install mkdocs.

set -euo pipefail

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
pip install mkdocs mkdocs-material

deactivate

echo "MkDocs installation complete."
