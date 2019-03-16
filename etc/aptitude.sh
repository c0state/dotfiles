#!/usr/bin/env bash

set -ex

# apt packages to install

#----- install mono

sudo apt-get install gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

aptitude install -y \
    mono-complete

#----- update

apt-get update

#----- install packages

apt-get install aptitude

# install utility packages
aptitude install -y \
    colordiff curl git gparted vim-nox wget \
    direnv \
    dos2unix \
    icdiff \
    parallel tree

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
    openjdk-8-jdk openjdk-11-jdk
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install node packages
aptitude install -y \
    nodejs npm

# install python packages
aptitude install -y \
    python-dev python-pip python3-pip

# install ruby packages
aptitude install -y \
    ruby-dev rbenv

# install zsh packages
aptitude install -y \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting
