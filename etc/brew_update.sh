#!/usr/bin/env bash

#---------- brew setup ----------

# exit on any failed command
set -e

brew update && brew upgrade

#---------- brew packages ----------

# package dependencies first
brew install gmp 

brew install ack
brew install ag
brew install ansible
brew install antigen
brew install apache-drill
brew install awscli
brew install bash homebrew/versions/bash-completion2
brew install bfg
brew install chromedriver
brew install cmake
brew install colordiff
brew install coreutils --with-gmp
brew install ddrescue
brew install direnv
brew install docker-cloud
brew install dos2unix
brew install exiftool
brew install ffmpeg --with-libvorbis
brew install --default-names findutils
brew install git git-extras legit
brew install go go-delve/delve/delve
brew install htop
brew install imagemagick
brew install TomAnthony/brews/itermocil
brew install jenkins
brew install jq
brew install macvim --with-lua
brew install mas
brew install mobile-shell
brew install mongodb
brew install mono
brew install mysql
brew install neovim/neovim/neovim
brew install node
brew install npm
brew install optipng
brew install packer
brew install parallel
brew install phantomjs
brew install pidcat
brew install pngquant
brew install postgresql
brew install python python3
brew install q
brew install ripgrep
brew install ruby rbenv rbenv-gemset ruby-build
brew install redis
brew install rlwrap
brew install smartmontools
brew install sshuttle
brew install stunnel
brew install svg2png
brew install terminator
brew install terraform
brew install tmux
brew install tree
brew install vim --override-system-vi --with-lua
brew install wget
brew install zsh zsh-completions zsh-syntax-highlighting

#---------- brew cask packages ----------

# install apps via brew cask
brew cask install 1password
brew cask install adobe-reader
brew cask install aerial
brew cask install android-studio
brew cask install android-studio-canary
brew cask install atom
brew cask install beyond-compare
brew cask install bitbar
brew cask install brave
brew cask install coconutbattery
brew cask install disk-inventory-x
brew cask install divvy
brew cask install datagrip
brew cask install docker
brew cask install etrecheck
brew cask install evernote
brew cask install fastlane
brew cask install filezilla
brew cask install firefox
brew cask install flux
brew cask install gimp
brew cask install gitkraken
brew cask install google-backup-and-sync
brew cask install google-cloud-sdk
brew cask install google-nik-collection
brew cask install google-play-music-desktop-player
brew cask install handbrake
brew cask install hwsensors
brew cask install imageoptim
brew cask install insync
brew cask install intellij-idea
brew cask install java
brew cask install jetbrains-toolbox
brew cask install lastpass
brew cask install libreoffice
brew cask install microsoft-office
brew cask install mono-mdk
brew cask install origami-studio
brew cask install prime95
brew cask install pycharm
brew cask install rubymine
brew cask install shadowsocksx-ng
brew cask install sketch
brew cask install sketch-toolbox
brew cask install skype
brew cask install slack
brew cask install sourcetree
brew cask install spectacle
brew cask install sqlitebrowser
brew cask install sqlitestudio
brew cask install sqlpro-for-sqlite
brew cask install staruml
brew cask install sublime-text
brew cask install teamviewer
brew cask install torbrowser
brew cask install tower
brew cask install vagrant
brew cask install virtualbox
brew cask install viscosity
brew cask install visual-studio
brew cask install visual-studio-code
brew cask install vlc
brew cask install vmware-fusion
brew cask install webstorm
brew cask install whatsapp
brew cask install wireshark
brew cask install xamarin
brew cask install xquartz inkscape

brew cleanup && brew cask cleanup && brew prune

echo "Finished installing brew and brew cask packages successfully."
