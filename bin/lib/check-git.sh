#!/usr/bin/env bash

# Purpose: Check if git is installed and executable.
# Exits with 1 if not found.

set -euo pipefail

if ! command -v git &>/dev/null; then
  echo "Error: git is not installed. Please install git and try again." >&2
  exit 1
fi

exit 0
