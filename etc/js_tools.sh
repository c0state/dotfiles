#!/usr/bin/env bash

set -eux

NODE_VERSION=24

# ---------- volta https://github.com/volta-cli/volta

curl https://get.volta.sh | bash -s -- --skip-setup

# ---------- install js tools

volta install node@"$NODE_VERSION"
volta install yarn

# ---------- install global packages

npm install --global npm

npm install --global \
    @anthropic-ai/claude-code \
    @github/copilot \
    @google/gemini-cli \
    @openai/codex \
    cdktf-cli \
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
