#!/usr/bin/env bash

set -ex

apt-get update

#----- install utility packages

apt install -y \
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

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable main" | tee /etc/apt/sources.list.d/mono-official-stable.list

apt update && apt install -y \
    mono-complete

#----- install packages

# install developer packages
apt install -y \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    vagrant

# install image packages
apt install -y \
    ffmpeg imagemagick pngquant

# install go packages
apt install -y \
    golang

# install java packages
apt install -y \
    default-jdk

# install rust packages
apt install -y \
    cargo

# install networking packages
apt install -y avahi-daemon samba winbind

# install node packages
curl -sL https://deb.nodesource.com/setup_12.x | bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update && apt install -y nodejs yarn

# install python packages
apt install -y \
    python-dev python-pip \
    python3-pip python3-venv

# install ruby packages
apt install -y \
    ruby-dev rbenv

# install zsh packages
apt install -y \
    zsh zsh-doc
