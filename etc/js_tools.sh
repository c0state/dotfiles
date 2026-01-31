#!/usr/bin/env bash

set -eux

NODE_VERSION=24

# ---------- volta https://github.com/volta-cli/volta

curl https://get.volta.sh | bash -s -- --skip-setup

if ! which bun; then
  curl -fsSL https://bun.com/install | bash
else
  bun upgrade
fi

# ---------- install js tools

volta install node@"$NODE_VERSION"
volta install yarn

# ---------- install global packages

bun add --global \
    @anthropic-ai/claude-code \
    @beads/bd \
    @github/copilot \
    @google/gemini-cli \
    @openai/codex \
    diff-so-fancy \
    git-split-diffs \
    imageoptim-cli \
    np \
    npm-check-updates \
    tldr

# ---------- install deno https://github.com/denoland/deno

if ! which deno; then
    curl -fsSL https://raw.githubusercontent.com/denoland/deno_install/master/install.sh | sh
else
    deno upgrade
fi
