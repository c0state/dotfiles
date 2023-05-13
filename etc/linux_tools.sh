#!/usr/bin/env bash

if [[ "$(uname)" != *"Linux"* ]]; then
  echo "This script is for Linux only, exiting"
  exit
fi

ARCH=$(uname -m)

# ---------- brew

if ! which brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ---------- aws

TEMP_AWS_INSTALL_DIR=$(mktemp --directory)
curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "$TEMP_AWS_INSTALL_DIR"/awscli.zip
unzip "$TEMP_AWS_INSTALL_DIR"/awscli.zip -d "$TEMP_AWS_INSTALL_DIR"
"$TEMP_AWS_INSTALL_DIR"/aws/install --install-dir "$HOME"/.local/awscli --bin-dir "$HOME"/.local/bin --update
rm -rf "$TEMP_AWS_INSTALL_DIR"

# ---------- gnome tweaks

if ! which gsettings > /dev/null; then
    # clear conflicting keybindings
    gsettings set org.freedesktop.ibus.panel.emoji hotkey []
fi
