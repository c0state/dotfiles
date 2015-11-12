#!/usr/bin/env bash

# exit on any failed command
set -e

brew update && brew upgrade

# install cask - https://github.com/caskroom/homebrew-cask
brew install caskroom/cask/brew-cask

# install apps via brew cask
brew cask install 1password
brew cask install atom
brew cask install beyond-compare
brew cask install google-drive
brew cask install intellij-idea
brew cask install lastpass
brew cask install macvim
brew cask install pycharm
brew cask install sourcetree
brew cask install vagrant
brew cask install virtualbox
brew cask install visual-studio-code
brew cask install webstorm

brew install ack
brew install ag
brew install antigen
brew install bash
brew install cmake
brew install --default-names findutils
brew install git
brew install go
brew install htop
brew install mono
brew install node
brew install npm
brew install packer
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper
brew install python python3
brew install tmux
brew install tree
brew install vim --override-system-vi --with-lua
brew install wget
brew install zsh-completions

echo "Finished installing brew packages successfully."
