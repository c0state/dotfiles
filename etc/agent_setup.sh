#!/usr/bin/env bash

set -eux

DEFAULT_VENV_PATH="$HOME/.local/share/python-venvs/default_python_venv"

# ---------- shared agent instructions (AGENTS.md)

mkdir -p "$HOME/.codex" "$HOME/.gemini" "$HOME/.copilot"
ln -s -f -n "$HOME/.dotfiles/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -s -f -n "$HOME/.dotfiles/AGENTS.md" "$HOME/.gemini/GEMINI.md"
ln -s -f -n "$HOME/.dotfiles/AGENTS.md" "$HOME/.copilot/copilot-instructions.md"

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

# ---------- chatgpt desktop official preview (debian/ubuntu only)

# no apt repo to pull from yet, so bootstrap via the vendor .deb; its
# postinst registers the chatgpt-archive-keyring + sources.list.d entry,
# after which a regular apt upgrade keeps it current
if command -v apt >/dev/null 2>&1 && ! dpkg --status chatgpt >/dev/null 2>&1; then
  CHATGPT_DEB="$(mktemp --suffix=.deb)"
  curl --fail --silent --show-error --location --output "$CHATGPT_DEB" \
    "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_$(dpkg --print-architecture).deb"
  sudo apt --yes install "$CHATGPT_DEB"
  rm -f "$CHATGPT_DEB"
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

# ---------- hermes agent

if ! command -v hermes >/dev/null 2>&1; then
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup
  # only apply defaults if no config exists yet — command -v failing just means
  # hermes isn't on PATH right now, not that this is a first-time install
  if [ ! -f "$HOME/.hermes/config.yaml" ]; then
    hermes setup --reset --non-interactive
  fi
else
  hermes update --yes
fi

# ---------- agent bun packages

bun add --global \
  @beads/bd \
  @github/copilot \
  @openai/codex \
  opencode-ai

# ---------- herdr (agent-aware terminal multiplexer)

if ! command -v herdr >/dev/null 2>&1; then
  curl -fsSL https://herdr.dev/install.sh | sh
else
  herdr update
fi

herdr integration install claude || true
herdr integration install copilot || true
herdr integration install opencode || true
herdr integration install hermes || true

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
npx -y skills add rohitg00/agentmemory -g -y || true

# install agentmemory plugin for claude-code (registers capture hooks; MCP
# connect + skills above do NOT do this on their own)
claude plugin marketplace add rohitg00/agentmemory || true
claude plugin install agentmemory@agentmemory || true

# wire and install the full agentmemory integration for codex CLI
agentmemory connect codex || true
codex plugin marketplace add rohitg00/agentmemory || true
codex plugin add agentmemory@agentmemory || true

# codex desktop does not currently load plugin hooks, so also install the
# global hooks workaround. agentmemory 0.9.27 exits early when MCP is already
# wired unless --force is used; guard it to avoid rewriting config every run.
CODEX_HOOKS="$HOME/.codex/hooks.json"
if [ ! -f "$CODEX_HOOKS" ] || ! grep -q 'agentmemory.*/plugin/scripts/' "$CODEX_HOOKS"; then
  agentmemory connect codex --force --with-hooks || true
fi

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

# ---------- ollama (available for ad-hoc local inference)

# deliberately no OLLAMA_IGPU_ENABLE override: on an APU laptop that puts
# inference on the same GPU the desktop compositor uses, which starves the UI
if ! command -v ollama >/dev/null 2>&1; then
  curl -fsSL https://ollama.com/install.sh | sh
fi

# agentmemory .env: LLM-gated features (idempotent — always re-asserts these
# values and restarts, no presence check needed). No LLM provider is configured,
# so agentmemory runs in noop mode: capture, synthetic compression and hybrid
# search still work; summarise / reflect / consolidate / graph-extract do not.
#
# AGENTMEMORY_AUTO_COMPRESS must stay false while there is no provider. With it
# on, capture takes the mem::compress path, the noop provider returns "", the
# XML parse fails, and the observation is never written to the store or added to
# the BM25/vector indexes. Off takes the buildSyntheticCompression branch, which
# does index. Flip back to true when a provider is configured.
AGENTMEMORY_ENV="$HOME/.agentmemory/.env"
mkdir -p "$(dirname "$AGENTMEMORY_ENV")"
touch "$AGENTMEMORY_ENV"
grep -vE '^(AGENTMEMORY_AUTO_COMPRESS|EMBEDDING_PROVIDER|OPENAI_API_KEY|OPENAI_BASE_URL|OPENAI_MODEL|GRAPH_EXTRACTION_ENABLED|AGENTMEMORY_INJECT_CONTEXT|AGENTMEMORY_LLM_TIMEOUT_MS)=' \
  "$AGENTMEMORY_ENV" >"$AGENTMEMORY_ENV.tmp" || true
mv "$AGENTMEMORY_ENV.tmp" "$AGENTMEMORY_ENV"
cat >>"$AGENTMEMORY_ENV" <<'EOF'
AGENTMEMORY_AUTO_COMPRESS=false
EMBEDDING_PROVIDER=local
GRAPH_EXTRACTION_ENABLED=true
AGENTMEMORY_INJECT_CONTEXT=true
EOF
case "$(uname -s)" in
Linux) systemctl --user restart agentmemory.service || true ;;
Darwin) launchctl kickstart -k "gui/$(id -u)/dev.agentmemory" || true ;;
esac

# ---------- rtk

if ! which rtk; then
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  rtk gain

  rtk init -g
  rtk init -g --gemini
  rtk init -g --codex
  [ -d "$HOME/.cursor" ] && rtk init -g --agent cursor
  [ -d "$HOME/.pi" ] && rtk init -g --agent pi
  [ -d "$HOME/.antigravity" ] && rtk init --agent antigravity
fi
