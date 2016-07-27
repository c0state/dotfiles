#!/usr/bin/env bash

set -ex

# packages to install on ubuntu

apt-get install aptitude
aptitude install curl git gparted vim-gnome wget \
    cmake \
    golang \
    mono-mcs mono-runtime mono-xbuild \
    nodejs nodejs-legacy npm \
    rbenv \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting -y
