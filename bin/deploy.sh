#!/usr/bin/env bash

# ---
# Deploy Script
#
# Orchestrates a full publish:
#   1. validate the site builds in strict mode (fail loud, before anything else)
#   2. commit and push the source to GitHub
#   3. publish the built site to GitHub Pages
# ---

set -euo pipefail

# === Locate the wiki root relative to this script ===
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
WIKI_ROOT="$( realpath "$SCRIPT_PATH/.." )"
cd "$WIKI_ROOT"

# === Step 1: Validate the build BEFORE touching git (strict, fail-fast) ===
"$WIKI_ROOT/bin/lib/check-build.sh"

# === Step 2: Handle commit message ===
if [[ -n "${1:-}" && ! "$1" =~ ^[[:space:]]*$ ]]; then
    message="$1"
else
    read -rp "Enter commit message: " message
fi

# === Step 3: Commit (only if there is something to commit) and push ===
echo "📦 Staging changes..."
git add .
if git diff --cached --quiet; then
    echo "ℹ️  No changes to commit — deploying current state."
else
    git commit -m "$message"
    echo "✅ Commit successful"
fi

echo "🚀 Pushing to GitHub..."
git push
echo "✅ Push successful"

# === Step 4: Publish to GitHub Pages ===
"$WIKI_ROOT/bin/lib/deploy-site.sh"
echo "✅ Deployment successful"
