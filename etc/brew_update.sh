#!/usr/bin/env bash

# exit on any failed command
set -e

# tap some extra homebrew repos
brew tap homebrew/gui

brew update && brew upgrade

# package dependencies first
brew install gmp 

brew install ack
brew install ag
brew install ansible
brew install antigen
brew install apache-drill
brew install bash homebrew/versions/bash-completion2
brew install chromedriver
brew install cmake
brew install colordiff
brew install coreutils --with-gmp
brew install docker docker-cloud docker-compose docker-machine docker-swarm
brew install dos2unix
brew install ffmpeg
brew install --default-names findutils
brew install git git-extras legit
brew install go
brew install htop
brew install macvim --with-lua
brew install mongodb
brew install mono
brew install mysql
brew install neovim/neovim/neovim
brew install nginx
brew install node
brew install npm
brew install packer
brew install postgresql
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper
brew install python python3
brew install rlwrap
brew install terminator
brew install tmux
brew install tree
brew install vim --override-system-vi --with-lua
brew install wget
brew install zsh zsh-completions zsh-syntax-highlighting

# install apps via brew cask
brew cask install 1password
brew cask install adobe-reader
brew cask install android-studio
brew cask install atom
brew cask install beyond-compare
brew cask install brave
brew cask install divvy
brew cask install datagrip
brew cask install dockertoolbox
brew cask install evernote
brew cask install exiftool
brew cask install filezilla
brew cask install flux
brew cask install google-drive
brew cask install google-nik-collection
brew cask install google-play-music-desktop-player
brew cask install gopro-studio
brew cask install hexchat
brew cask install intellij-idea
brew cask install java
brew cask install jenkins
brew cask install lastpass
brew cask install libreoffice
brew cask install otto
brew cask install pycharm
brew cask install robomongo
brew cask install sourcetree
brew cask install sqlitebrowser
brew cask install terraform
brew cask install tower
brew cask install vagrant
brew cask install virtualbox
brew cask install visual-studio-code
brew cask install vmware-fusion
brew cask install webstorm

brew cleanup && brew cask cleanup

echo "Finished installing brew and brew cask packages successfully."
