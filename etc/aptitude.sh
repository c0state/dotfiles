#!/usr/bin/env bash

set -eu

IS_WSL=$(uname -a | grep -i microsoft || echo "")

# init vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f /tmp/packages.microsoft.gpg

# init github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# init tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# tabby
curl -fsSL https://packagecloud.io/eugeny/tabby/gpgkey | gpg --dearmor | sudo dd of=/etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg] https://packagecloud.io/eugeny/tabby/ubuntu kinetic main" | sudo tee /etc/apt/sources.list.d/eugeny_tabby.list
echo "deb-src [signed-by=/etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg] https://packagecloud.io/eugeny/tabby/ubuntu kinetic main" | sudo tee -a /etc/apt/sources.list.d/eugeny_tabby.list

#------------------------------ ppas

sudo add-apt-repository -y ppa:touchegg/stable

#------------------------------ begin update and installs

sudo apt-get update

#------------------------------ install core packages

sudo apt -y install \
    flatpak \
    snapd

#------------------------------ flatpak repos

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub

flatpak install -y touche

#------------------------------ install utility packages

sudo apt -y install \
    bat \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    fd-find \
    git git-lfs \
    glances \
    gparted \
    gnome-tweaks \
    gnupg gpg ca-certificates \
    keychain \
    ncdu \
    nethogs \
    parallel \
    ranger \
    ripgrep \
    tabby-terminal \
    tree \
    wmctrl \
    vim-nox

#------------------------------ install packages

# install compiler packages
sudo apt -y install \
    build-essential cmake \
    zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libssl-dev llvm \
    libncurses5-dev libncursesw5-dev \
    libxml2-dev

# TODO: figure out how to add repo
# only available on pop os out of the box
#sudo apt -y install alacritty

# install developer packages
sudo apt -y install \
    awscli \
    fonts-firacode \
    gh \
    tmux \
    vagrant

# TODO: skip on wsl
# install vscode
sudo apt install code

# install browsers
sudo apt install fonts-liberation

# chrome isn't in core repos for ubuntu
apt info google-chrome-stable && sudo apt install google-chrome-stable
which google-chrome-stable || bash -i -c "install_package https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# install image packages
sudo apt -y install \
    ffmpeg imagemagick pngquant

# install java packages
sudo apt -y install \
    default-jdk

# install networking packages
sudo apt -y install avahi-daemon samba \
    tailscale \
    winbind

# install db packages
sudo apt -y install libpq-dev postgresql-client

# install python packages
sudo apt -y install \
    python3-dev python3-pip python3-venv python-is-python3

# install ruby packages
sudo apt -y install \
    ruby-dev

# install shell packages
sudo apt -y install \
    fish \
    zsh zsh-doc

sudo apt install -y touchegg

