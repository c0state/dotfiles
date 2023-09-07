#!/usr/bin/env bash

set -eu

if ! command -v rustc >/dev/null 2>&1; then
    curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | bash -s -- -y
else
    rustup update
    rustup self update
fi

source "$HOME"/.cargo/env

cargo install --locked --features clipboard broot
cargo install --locked coreutils
cargo install --locked exa
cargo install --locked git-delta
cargo install --locked sd
cargo install --locked tree-sitter-cli
