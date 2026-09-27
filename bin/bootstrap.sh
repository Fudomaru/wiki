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
clone_repository() {
  print_header "Step 1: Cloning Repository"
  if [ -d "$INSTALL_DIR" ]; then
    echo "✅ Directory '$INSTALL_DIR' already exists. Skipping clone."
  else
    # Git is required to fetch the repo. The formal check lives in
    # bin/lib/check-git.sh, but that file is inside the repo we have not
    # cloned yet — so this single precondition has to be inline.
    if ! command_exists "git"; then
      echo "Error: Git is not installed. Please install Git and run this script again." >&2
      exit 1
    fi
    echo "Cloning repository from '$REPO_URL' into '$INSTALL_DIR'..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    echo "✅ Repository cloned successfully."
  fi
}

verify_toolchain() {
  print_header "Step 2: Verifying Toolchain"
  cd "$INSTALL_DIR"
  echo "🔎 Verifying required tools..."
  ./bin/lib/check-git.sh
  ./bin/lib/check-python.sh
  echo "✅ Toolchain present (git, python3)."
}

install_dependencies() {
  print_header "Step 3: Installing Dependencies"
  cd "$INSTALL_DIR"
  echo "🐍 Installing MkDocs and pinned dependencies..."
  ./bin/lib/install-mkdocs.sh
}

# --- Main Execution ---
main() {
  clone_repository
  verify_toolchain
  install_dependencies

  print_header "🎉 Bootstrap Complete! 🎉"
  echo "The project is now set up in '$INSTALL_DIR'."
  echo "You can now 'cd $INSTALL_DIR' and start working."
  echo
}

main "$@"
