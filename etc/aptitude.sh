#!/usr/bin/env bash

set -ex

# various apt packages to install

#----- update and install aptitude

apt-get update
apt-get install aptitude

#----- install utility packages

aptitude install -y \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    git \
    gparted \
    gnupg ca-certificates \
    parallel \
    tree \
    vim-nox

#----- install mono

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list

aptitude install -y \
    mono-complete

#----- install packages

# install developer packages
aptitude install -y \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    vagrant

# install image packages
aptitude install -y \
    imagemagick pngquant

# install go packages
aptitude install -y \
    golang

# install java packages
aptitude install -y \
    openjdk-12-jdk

# install networking packages
aptitude install -y avahi-daemon samba winbind

# install node packages
curl -sL https://deb.nodesource.com/setup_11.x | bash -
aptitude install -y nodejs

# install python packages
aptitude install -y \
    python-dev python-pip python3-pip

# install ruby packages
aptitude install -y \
    ruby-dev rbenv

# install zsh packages
aptitude install -y \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting
