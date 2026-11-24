#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  MINGW*|MSYS*) ;;
  *)
    printf 'Run this script from Git Bash on Windows.\n' >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/python.sh"
