#!/usr/bin/env bash
# Headless nvim test runner for nvim-wyn.
# Loads the plugin with a minimal init and runs tests/run.lua. Requires `nvim`;
# LSP checks additionally require the `wyn` binary on PATH (set $WYN to override).
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v nvim >/dev/null 2>&1; then
  echo "nvim-wyn tests: SKIP (nvim not found)"
  exit 0
fi

nvim --headless -u tests/minimal_init.lua -l tests/run.lua
