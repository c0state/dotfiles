#!/usr/bin/env bash

set -eu

# ----------

GITHUB_TOKEN_SCRIPTS=${GITHUB_TOKEN_SCRIPTS:-""}

# ----------

if ! command -v rustc >/dev/null 2>&1; then
    curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | bash -s -- -y
else
    rustup update
    rustup self update
fi

rustup component add rust-analyzer

source "$HOME"/.cargo/env

cargo install --features clipboard broot
PROJECT_NAME_FOR_VERSION_STRING="uutils coreutils" cargo install coreutils
cargo install eza
cargo install git-delta
cargo install sd
cargo install tree-sitter-cli
cargo install wasm-pack
cargo install zellij

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  if [ -n "$GITHUB_TOKEN_SCRIPTS" ]; then
    TOKEN_ARG="--token $GITHUB_TOKEN_SCRIPTS"
  else
    TOKEN_ARG=""
  fi
  uv self update $TOKEN_ARG
fi

