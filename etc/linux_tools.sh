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

if test -w /home/linuxbrew/.linuxbrew; then
  brew update
  brew upgrade

  brew install derailed/k9s/k9s
  brew install neovim
  brew install nerdctl
  brew install nushell
  brew install ripgrep-all
  brew install yq
else
  echo "Linuxbrew dir not writable, was it installed by a different user?"
fi

# ---------- aws

TEMP_AWS_INSTALL_DIR=$(mktemp --directory)
curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "$TEMP_AWS_INSTALL_DIR"/awscli.zip
unzip "$TEMP_AWS_INSTALL_DIR"/awscli.zip -d "$TEMP_AWS_INSTALL_DIR"
"$TEMP_AWS_INSTALL_DIR"/aws/install --install-dir "$HOME"/.local/awscli --bin-dir "$HOME"/.local/bin --update
rm -rf "$TEMP_AWS_INSTALL_DIR"

# ---------- ghostty

if ! command -v ghostty &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi

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
  gsettings set org.gnome.shell.extensions.tiling-assistant dynamic-keybinding-behavior 2
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-tiling-popup false
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-raise-tile-group false
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-left-half "['<Super>Left']"
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-right-half "['<Super>Right']"
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-bottom-half "['<Super>Down']"
  gsettings set org.gnome.shell.extensions.tiling-assistant restore-window []

  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi

curl -L -s 'https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable' | \
  jq -r '.downloadUrl' | \
  xargs -I{} bash -c 'f=~/.local/bin/cursor; curl -L -o "$f" {}; chmod +x "$f"'

# ---------- local applications data

mkdir -p ~/.local/share/applications

# google chrome desktop launcher override with touchpad overscroll (for 2 finger swipe navigation)
GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE="$HOME/.local/share/applications/google-chrome.desktop"
if [[ ! -f "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE" ]]; then
  cp /usr/share/applications/google-chrome.desktop "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE"

  sed -i -E 's#^(Exec=.*(google-chrome(-stable)?))#\1 --enable-features=TouchpadOverscrollHistoryNavigation#' \
    "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE"
fi

