#!/usr/bin/env bash

set -e

sudo add-apt-repository --yes ppa:neovim-ppa/stable

sudo apt-get update

#----- install utility packages

sudo apt -y install \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    fd-find \
    git git-lfs \
    gparted \
    gnupg ca-certificates \
    keychain \
    nethogs \
    parallel \
    ranger \
    ripgrep \
    tree \
    vim-nox

#----- install packages

# install developer packages
sudo apt -y install \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev

# install ide packages
sudo apt -y install \
    fonts-firacode \
    neovim \
    tmux \
    vagrant

# install image packages
sudo apt -y install \
    ffmpeg imagemagick pngquant

# install java packages
sudo apt -y install \
    default-jdk

# install networking packages
sudo apt -y install avahi-daemon samba winbind

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
