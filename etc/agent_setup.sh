#!/usr/bin/env bash

set -eux

PLATFORM=$(uname)

# ---------- claude code

if ! which claude; then
  curl -fsSL https://claude.ai/install.sh | bash
else
  claude update
fi

# link desktop config (macOS only)
if [[ "$PLATFORM" == "Darwin" ]]; then
  mkdir -p "$HOME/Library/Application Support/Claude"
  ln -f -s "$HOME/.dotfiles/osx_configs/claude_desktop_config.json" \
    "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
fi

# symlink claude user settings
mkdir -p "$HOME/.claude"
ln -s -f -n "$HOME/.dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"

# install claude plugins
# NOTE: verify plugin names with `claude plugin list` or claude.ai/plugins
claude plugin install typescript-lsp@anthropics-claude-code || true
claude plugin install pyright-lsp@anthropics-claude-code || true

# ---------- gemini cli (installed via bun in js_tools.sh — config here if needed)
# ---------- openai codex (installed via bun in js_tools.sh — config here if needed)
