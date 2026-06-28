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

# ---------- claude desktop (debian/ubuntu only)

if command -v apt >/dev/null 2>&1; then
  curl -fsSL https://aaddrick.github.io/claude-desktop-debian/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/claude-desktop.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/claude-desktop.gpg arch=amd64,arm64] https://pkg.claude-desktop-debian.dev stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
  sudo apt update
  sudo apt -y install claude-desktop
fi

# ---------- copilot cli session-pin extension

mkdir -p "$HOME/.copilot/extensions/session-pin"
ln -s -f -n \
  "$HOME/.dotfiles/agents/copilot/extensions/session-pin/extension.mjs" \
  "$HOME/.copilot/extensions/session-pin/extension.mjs"

# ---------- gemini cli

if ! command -v agy >/dev/null 2>&1; then
  curl -fsSL https://antigravity.google/cli/install.sh | bash
else
  agy update
fi

# ---------- agent bun packages

bun add --global \
  @beads/bd \
  @github/copilot \
  @openai/codex \
  opencode-ai

# ---------- openai python sdk

uv pip install -p "$DEFAULT_VENV_PATH" --upgrade openai

# ---------- rtk (multi-agent router)

if ! which rtk; then
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  rtk gain

  rtk init -g
  rtk init -g --gemini
  rtk init -g --codex
  rtk init -g --agent cursor
  rtk init -g --agent pi
  rtk init --agent antigravity
fi
