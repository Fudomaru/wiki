#!/usr/bin/env bash

# ---
# Bootstrap Script
#
# This script sets up the entire project on a new machine.
# It can be run remotely via curl, e.g.:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/fudomaru/wiki/main/bin/bootstrap.sh)"
# ---

set -euo pipefail

# --- Configuration ---
REPO_URL="https://github.com/fudomaru/wiki.git"
INSTALL_DIR="$HOME/Projects/wiki"

# --- Helper Functions ---
print_header() {
  echo
  echo "================================================================================"
  echo " $1"
  echo "================================================================================"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Main Functions ---
check_for_git() {
  print_header "Step 1: Checking for Git"
  if ! command_exists "git"; then
    echo "Error: Git is not installed. Please install Git and run this script again." >&2
    exit 1
  fi
  echo "✅ Git is installed."
}

clone_repository() {
  print_header "Step 2: Cloning Repository"
  if [ -d "$INSTALL_DIR" ]; then
    echo "✅ Directory '$INSTALL_DIR' already exists. Skipping clone."
  else
    echo "Cloning repository from '$REPO_URL' into '$INSTALL_DIR'..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    echo "✅ Repository cloned successfully."
  fi
}

setup_project() {
  print_header "Step 3: Setting Up Project Dependencies"
  cd "$INSTALL_DIR"

  echo "🔎 Checking for Python..."
  ./bin/lib/check-python.sh
  echo "✅ Python check passed."

  echo "🐍 Installing MkDocs and dependencies..."
  ./bin/lib/install-mkdocs.sh
}

# --- Main Execution ---
main() {
  check_for_git
  clone_repository
  setup_project

  print_header "🎉 Bootstrap Complete! 🎉"
  echo "The project is now set up in '$INSTALL_DIR'."
  echo "You can now 'cd $INSTALL_DIR' and start working."
  echo
}

main "$@"
