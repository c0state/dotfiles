#!/usr/bin/env bash

if ! $(command -v rustc >/dev/null 2>&1); then
    curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | bash -s -- -y
else
    rustup update
    rustup self update
fi

source "$HOME/.cargo/env"

# utilities to install from source
cargo install sd
cargo install git-delta
