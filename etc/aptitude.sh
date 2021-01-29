#!/usr/bin/env -S bash -i

set -e

sudo apt-get update

#----- install utility packages

sudo apt install -y \
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

sudo apt update && sudo apt install -y \
    mono-complete

#----- install packages

# install developer packages
sudo apt install -y \
    build-essential cmake zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev libxml2-dev \
    neovim \
    vagrant

# install image packages
sudo apt install -y \
    ffmpeg imagemagick pngquant

# install go packages
sudo apt install -y \
    golang

# install java packages
sudo apt install -y \
    default-jdk

# install networking packages
sudo apt install -y avahi-daemon samba winbind

#----- install node packages

# set up node repo and install
sudo bash -c 'curl -sL https://deb.nodesource.com/setup_15.x | bash -'
sudo apt update && sudo apt install -y nodejs

# set default node and install yarn via npm
nvm install 15
nvm alias default 15
nvm use default
npm install --global yarn

# install db packages
sudo apt install -y libpq-dev

# install python packages
sudo apt install -y \
    python3-dev python3-pip

# install ruby packages
sudo apt install -y \
    ruby-dev rbenv

# install zsh packages
sudo apt install -y \
    zsh zsh-doc

if ! $(which lsd > /dev/null); then
    install_package "https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb"
fi

