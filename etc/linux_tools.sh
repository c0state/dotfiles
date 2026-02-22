#!/usr/bin/env bash

set -eu

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
  INSTALLED_SCHEMAS="$(gsettings list-schemas)"

  gset() {
    local schema="$1"
    local key="$2"
    local value="$3"
    
    # Extract base schema if contains : (for relocatable schemas)
    local schema_base="${schema%%:*}"

    if echo "$INSTALLED_SCHEMAS" | grep -F -x -q "$schema_base"; then
      gsettings set "$schema" "$key" "$value"
    fi
  }

  # clear conflicting keybindings
  gset org.freedesktop.ibus.panel.emoji hotkey []
  
  # caps lock as ctrl
  gset org.gnome.desktop.input-sources xkb-options '["caps:ctrl_modifier"]'
  gset org.gnome.desktop.interface clock-show-weekday true 
  
  # auto hide dock
  gset org.gnome.shell.extensions.dash-to-dock dock-fixed false

  # set custom key bindings
  # note: this will overwrite existing ones
  gset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'toggle-terminal'"
  gset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'guake-toggle'"
  gset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Control><Alt>i'"

  # tiling assistant
  gset org.gnome.shell.extensions.tiling-assistant dynamic-keybinding-behavior 2
  gset org.gnome.shell.extensions.tiling-assistant enable-tiling-popup false
  gset org.gnome.shell.extensions.tiling-assistant enable-raise-tile-group false
  gset org.gnome.shell.extensions.tiling-assistant tile-left-half "['<Super>Left']"
  gset org.gnome.shell.extensions.tiling-assistant tile-right-half "['<Super>Right']"
  gset org.gnome.shell.extensions.tiling-assistant tile-bottom-half "['<Super>Down']"
  gset org.gnome.shell.extensions.tiling-assistant restore-window []

  gset org.gnome.settings-daemon.plugins.color night-light-enabled true
fi

# ---------- sysctl tweaks

cat <<EOF | sudo tee /etc/sysctl.d/99-vscode.conf
fs.inotify.max_user_watches=524288
EOF
sudo sysctl fs.inotify.max_user_watches=524288

# ---------- nerd fonts

mkdir -p ~/.local/share/fonts/NerdFonts && \
wget -q -O- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip |\
  bsdtar -x -f - -C "$HOME"/.local/share/fonts/NerdFonts -

wget -q -O- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip | \
  bsdtar -x -f - -C "$HOME"/.local/share/fonts/NerdFonts -

fc-cache --force --verbose >/dev/null

# ---------- local applications data

mkdir -p ~/.local/share/applications

# google chrome desktop launcher override with touchpad overscroll (for 2 finger swipe navigation)
GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE="$HOME/.local/share/applications/google-chrome.desktop"
if [[ ! -f "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE" ]]; then
  cp /usr/share/applications/google-chrome.desktop "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE"

  sed -i -E 's#^(Exec=.*(google-chrome(-stable)?))#\1 --enable-features=TouchpadOverscrollHistoryNavigation#' \
    "$GOOGLE_CHROME_DESKTOP_LAUNCHER_FILE"
fi
