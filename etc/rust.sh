#!/usr/bin/env bash

set -eu

# ----------

GITHUB_TOKEN_SCRIPTS=${GITHUB_TOKEN_SCRIPTS:-""}

# ---------- rustup

curl --proto '=https' --tls-max default -sSf https://sh.rustup.rs | bash -s -- -y

rustup component add rust-analyzer

source "$HOME"/.cargo/env

# ---------- cargo

if ! command -v cargo-binstall >/dev/null 2>&1; then
	curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
else
	cargo binstall -y cargo-binstall
fi

cargo binstall -y broot
cargo binstall -y eza
cargo binstall -y jj-cli
cargo binstall -y sd
cargo binstall -y systemd-manager-tui
cargo binstall -y tealdeer
cargo binstall -y wasm-pack
cargo binstall -y zellij

# ---------- uv

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

tldr --update
