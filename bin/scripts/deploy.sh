#!/bin/bash

# === Step 1: Define base directory relative to script ===
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WIKI_ROOT="$( realpath "$SCRIPT_PATH/.." )"
cd "$WIKI_ROOT" || { echo "❌ Could not cd to wiki root"; exit 1; }

# === Step 2: Handle commit message ===
if [[ -n "$1" && ! "$1" =~ ^[[:space:]]*$ ]]; then
    message="$1"
else
    read -rp "Enter commit message: " message
fi

# === Step 3: Git commit and push ===
echo "📦 Adding changes..."
git add .
git commit -m "$message"
if [[ $? -eq 0 ]]; then
    echo "✅ Commit successful"
else
    echo "⚠️ Commit failed or nothing to commit"
fi

echo "🚀 Pushing to GitHub..."
git push
if [[ $? -eq 0 ]]; then
    echo "✅ Push successful"
else
    echo "❌ Push failed"
    exit 1
fi

# === Step 4: Deploy with MkDocs ===
echo "🌍 Deploying with mkdocs..."

VENV_DIR="$HOME/.mkdocs-env"
MKDOCS_BIN="$VENV_DIR/bin/mkdocs"

if [ ! -x "$MKDOCS_BIN" ]; then
    echo "❌ MkDocs binary not found at $MKDOCS_BIN"
    echo "➡️  Create it with: python3 -m venv $VENV_DIR && source $VENV_DIR/bin/activate && pip install mkdocs"
    exit 1
fi

"$MKDOCS_BIN" gh-deploy

if [[ $? -eq 0 ]]; then
    echo "✅ Deployment successful"
else
    echo "❌ Deployment failed"
    exit 1
fi

