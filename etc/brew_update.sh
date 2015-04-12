#!/usr/bin/env bash

# exit on any failed command
set -e

brew update && brew upgrade

# install cask - https://github.com/caskroom/homebrew-cask
brew install caskroom/cask/brew-cask

# install apps via brew cask
brew cask install atom
brew cask install sourcetree
brew cask install vagrant
brew cask install virtualbox

# install cask managed binaries
brew install homebrew/binary/packer

brew install ack
brew install ag
brew install bash
brew install --default-names findutils
brew install git
brew install htop
brew install mono
brew install node
brew install npm
brew install pyenv-virtualenv pyenv-virtualenvwrapper
brew install python python3
brew install tmux
brew install tree
brew install wget

echo "Finished installing brew packages successfully."
