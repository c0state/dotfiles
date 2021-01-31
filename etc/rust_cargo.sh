#!/usr/bin/env bash

if ! $(command -v rustc >/dev/null 2>&1); then
    curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | sh
fi

source "$HOME/.cargo/env"
