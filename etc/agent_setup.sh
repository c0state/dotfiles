#!/usr/bin/env bash

set -eux

DEFAULT_VENV_PATH="$HOME/.local/share/python-venvs/default_python_venv"

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

# ---------- claude desktop official (debian/ubuntu only)

if command -v apt >/dev/null 2>&1; then
  sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
  echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop-official.list
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

# ---------- agentmemory (local memory server for AI coding agents)

if ! command -v agentmemory >/dev/null 2>&1; then
  npm install -g @agentmemory/agentmemory
fi

# wire MCP config for claude-code (idempotent)
agentmemory connect claude-code || true

# install agentmemory skills for all agents (idempotent)
npx skills add rohitg00/agentmemory -g -y || true

# user service for auto-start on login
case "$(uname -s)" in
Linux)
  AGENTMEMORY_SERVICE="$HOME/.config/systemd/user/agentmemory.service"
  if [ ! -f "$AGENTMEMORY_SERVICE" ]; then
    mkdir -p "$(dirname "$AGENTMEMORY_SERVICE")"
    cat >"$AGENTMEMORY_SERVICE" <<'EOF'
[Unit]
Description=agentmemory local memory server for AI coding agents
After=network.target

[Service]
Type=simple
ExecStart=%h/.local/share/mise/shims/agentmemory
WorkingDirectory=%h/.agentmemory
Restart=on-failure
RestartSec=5
TimeoutStopSec=5

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable agentmemory.service
    systemctl --user start agentmemory.service
  fi
  ;;
Darwin)
  AGENTMEMORY_PLIST="$HOME/Library/LaunchAgents/dev.agentmemory.plist"
  if [ ! -f "$AGENTMEMORY_PLIST" ]; then
    mkdir -p "$(dirname "$AGENTMEMORY_PLIST")"
    cat >"$AGENTMEMORY_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>dev.agentmemory</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.local/share/mise/shims/agentmemory</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$HOME/.agentmemory</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF
    launchctl load -w "$AGENTMEMORY_PLIST"
  fi
  ;;
esac

# ---------- rtk

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
