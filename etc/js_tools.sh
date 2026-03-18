#!/usr/bin/env bash

set -eux

NODE_VERSION=25

# ---------- bun

if ! which bun; then
	curl -fsSL https://bun.com/install | bash

	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
else
	bun upgrade
fi

# ---------- install js tools

mise use --global node@"$NODE_VERSION"
npm install -g corepack
corepack enable
corepack prepare yarn@stable --activate

# ---------- install global packages

bun add --global \
	@beads/bd \
	@github/copilot \
	@google/gemini-cli \
	@googleworkspace/cli \
	@j178/prek \
	@openai/codex \
	diff-so-fancy \
	git-split-diffs \
	imageoptim-cli \
	np \
	npm-check-updates

# ---------- install claude code (native installer)

if ! which claude; then
	curl -fsSL https://claude.ai/install.sh | bash
else
	claude update
fi

# ---------- install deno https://github.com/denoland/deno

if ! which deno; then
	curl -fsSL https://raw.githubusercontent.com/denoland/deno_install/master/install.sh | sh
else
	deno upgrade
fi
