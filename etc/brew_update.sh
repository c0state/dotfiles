#!/usr/bin/env bash

# exit on any failed command
set -e

brew update && brew upgrade && brew cleanup && brew cask cleanup

brew install ack
brew install ag
brew install ansible
brew install antigen
brew install bash homebrew/versions/bash-completion2
brew install caskroom/cask/brew-cask # https://github.com/caskroom/homebrew-cask
brew install chromedriver
brew install cmake
brew install colordiff
brew install --default-names findutils
brew install git legit
brew install go
brew install htop
brew install macvim --with-lua
brew install mono
brew install node
brew install npm
brew install packer
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper
brew install python python3
brew install rlwrap
brew install tmux
brew install tree
brew install vim --override-system-vi --with-lua
brew install wget
brew install zsh-completions

# install apps via brew cask
brew cask install 1password
brew cask install adobe-reader
brew cask install atom
brew cask install beyond-compare
brew cask install flux
brew cask install google-drive
brew cask install intellij-idea
brew cask install lastpass
brew cask install pycharm
brew cask install sourcetree
brew cask install vagrant
brew cask install virtualbox
brew cask install visual-studio-code
brew cask install webstorm

echo "Finished installing brew packages successfully."
