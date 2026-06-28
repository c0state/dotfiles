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
  @googleworkspace/cli \
  @j178/prek \
  ccusage \
  diff-so-fancy \
  git-split-diffs \
  imageoptim-cli \
  np \
  npm-check-updates

# ---------- install deno https://github.com/denoland/deno

if ! which deno; then
  curl -fsSL https://raw.githubusercontent.com/denoland/deno_install/master/install.sh | sh
else
  deno upgrade
fi
