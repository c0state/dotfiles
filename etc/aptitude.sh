#!/usr/bin/env bash

set -e

sudo apt-get update

#----- install utility packages

sudo apt -y install \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    fd-find \
    git \
    gparted \
    gnupg ca-certificates \
    parallel \
    ranger \
    tree \
    vim-nox

#----- install packages

# install developer packages
sudo apt -y install \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    neovim \
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
sudo apt -y install libpq-dev

# install python packages
sudo apt -y install \
    python3-dev python3-pip python3-venv python-is-python3

# install ruby packages
sudo apt -y install \
    ruby-dev

# install zsh packages
sudo apt -y install \
    zsh zsh-doc
