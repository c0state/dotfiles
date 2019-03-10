#!/usr/bin/env bash

set -ex

# apt packages to install

#----- set up keys and repos

curl https://download.mono-project.com/repo/xamarin.gpg | sudo apt-key add -
echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list

#----- update

apt-get update

#----- install packages

apt-get install aptitude
aptitude install -y \
    colordiff curl git gparted vim-nox wget \
    direnv \
    dos2unix \
    golang \
    build-essential cmake libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    mono-complete \
    parallel tree \
    vagrant

# install image packages
aptitude install -y \
    imagemagick pngquant

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
