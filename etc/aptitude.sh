#!/usr/bin/env bash

set -e

sudo apt-get update

#----- install utility packages

sudo apt -y install \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    git \
    gparted \
    gnupg ca-certificates \
    parallel \
    ranger \
    tree \
    vim-nox

#----- install mono

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo bash -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable main" | tee /etc/apt/sources.list.d/mono-official-stable.list'

sudo apt -y update && sudo apt -y install \
    mono-complete

#----- install packages

# install developer packages
sudo apt -y install \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    neovim \
    vagrant

# install image packages
sudo apt -y install \
    ffmpeg imagemagick pngquant

# install go packages
sudo apt -y install \
    golang

# install java packages
sudo apt -y install \
    default-jdk

# install networking packages
sudo apt -y install avahi-daemon samba winbind

#----- install node packages

# set up node repo and install
sudo bash -c 'curl -sL https://deb.nodesource.com/setup_15.x | bash -'
sudo apt -y update && sudo apt -y install nodejs

# install db packages
sudo apt -y install libpq-dev

# install python packages
sudo apt -y install \
    python3-dev python3-pip python3-venv python-is-python3

# install ruby packages
sudo apt -y install \
    ruby-dev rbenv

# install zsh packages
sudo apt -y install \
    zsh zsh-doc
