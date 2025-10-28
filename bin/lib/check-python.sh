#!/usr/bin/env bash

# Purpose: Check if python3 is installed and executable.
# Exits with 1 if not found.

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is not installed. Please install python3 and try again." >&2
  exit 1
fi

exit 0
