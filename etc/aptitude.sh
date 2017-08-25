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
aptitude install -y \
    curl git gparted vim-gnome wget \
    direnv \
    dos2unix \
    golang \
    build-essential cmake libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    mono-complete \
    tree \
    vagrant

# install image packages
aptitude install -y \
    imagemagick pngquant

# install java packages
aptitude install -y \
    openjdk-8-jdk openjdk-9-jdk
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install node packages
aptitude install -y \
    nodejs nodejs-legacy npm

# install python packages
aptitude install -y \
    python-dev python-pip python3-pip

# install ruby packages
aptitude install -y \
    ruby-dev rbenv

# install zsh packages
aptitude install -y \
    zsh zsh-antigen zsh-doc zsh-syntax-highlighting
