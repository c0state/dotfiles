#!/usr/bin/env bash

set -ex

# apt packages to install

#----- set up keys and repos

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list

#----- update

apt-get update

#----- install packages

apt-get install aptitude
aptitude install \
    curl git gparted vim-gnome wget \
    cmake \
    direnv \
    golang \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    mono-complete \
    nodejs nodejs-legacy npm \
    python-dev python-pip python3-pip \
    ruby-dev rbenv \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting -y
