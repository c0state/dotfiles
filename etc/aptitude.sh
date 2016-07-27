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
aptitude install curl git gparted vim-gnome wget \
    cmake \
    golang \
    mono-complete \
    nodejs nodejs-legacy npm \
    rbenv \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting -y
