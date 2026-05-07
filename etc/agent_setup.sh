#!/usr/bin/env bash

set -eux

# ---------- claude code

if ! which claude; then
  curl -fsSL https://claude.ai/install.sh | bash
else
  claude update
fi

# symlink claude user settings
mkdir -p "$HOME/.claude"
ln -s -f -n "$HOME/.dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"

# install claude plugins
claude plugin install typescript-lsp@claude-plugins-official || true
claude plugin install pyright-lsp@claude-plugins-official || true

claude plugin marketplace add aws/agent-toolkit-for-aws || true
claude plugin install aws-core@agent-toolkit-for-aws || true

# ---------- copilot cli session-pin extension

mkdir -p "$HOME/.copilot/extensions/session-pin"
ln -s -f -n \
  "$HOME/.dotfiles/agents/copilot/extensions/session-pin/extension.mjs" \
  "$HOME/.copilot/extensions/session-pin/extension.mjs"

# ---------- gemini cli (installed via bun in js_tools.sh — config here if needed)

# ---------- openai codex (installed via bun in js_tools.sh — config here if needed)
