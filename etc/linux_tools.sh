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

brew install nerdctl

# ---------- aws

TEMP_AWS_INSTALL_DIR=$(mktemp --directory)
curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "$TEMP_AWS_INSTALL_DIR"/awscli.zip
unzip "$TEMP_AWS_INSTALL_DIR"/awscli.zip -d "$TEMP_AWS_INSTALL_DIR"
"$TEMP_AWS_INSTALL_DIR"/aws/install --install-dir "$HOME"/.local/awscli --bin-dir "$HOME"/.local/bin --update
rm -rf "$TEMP_AWS_INSTALL_DIR"

# ---------- gnome tweaks

if which gsettings > /dev/null; then
  # clear conflicting keybindings
  gsettings set org.freedesktop.ibus.panel.emoji hotkey []
  # caps lock as ctrl
  gsettings set org.gnome.desktop.input-sources xkb-options '["caps:ctrl_modifier"]'
  gsettings set org.gnome.desktop.interface clock-show-weekday true 
  # auto hide dock
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

  # set custom key bindings
  # note: this will overwrite existing ones
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'toggle-terminal'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'guake-toggle'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Control><Alt>i'"

  # tiling assistant
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-tiling-popup false
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-bottom-half "['<Super>Down', '<Super>KP_2']"
fi
