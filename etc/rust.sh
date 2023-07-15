#!/usr/bin/env bash

set -eu

if ! command -v rustc >/dev/null 2>&1; then
    curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | bash -s -- -y
else
    rustup update
    rustup self update
fi

source "$HOME"/.cargo/env

cargo install coreutils
cargo install exa
cargo install git-delta
cargo install sd
cargo install tree-sitter-cli
