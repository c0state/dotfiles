#!/usr/bin/env bash

#---------- brew setup ----------

# exit on any failed command
set -e

# add taps
brew tap caskroom/versions
brew tap busterc/tap

brew update && brew upgrade && brew cask upgrade

#---------- high level dependencies ----------

# need to install items from the app store
brew install mas
# java is needed for some apps
brew cask install java

#---------- brew packages ----------

# package dependencies first
brew install gmp 

brew install ack
brew install ag
brew install ansible
brew install antigen
brew install apache-drill
brew install awscli
brew install bash-completion@2
brew install bfg
brew install carthage
brew install cmake
brew install cocoapods
brew install colordiff icdiff
brew install coreutils
brew install ddrescue
brew install diff-so-fancy
brew install direnv
brew install dnsmasq
brew install docker-cloud
brew install dos2unix
brew install exiftool
brew install ffmpeg
brew install findutils
brew install fzf
brew install git git-extras git-lfs legit
brew install glances
brew install go
brew install htop
brew install imagemagick
brew install TomAnthony/brews/itermocil
brew install jq
brew install lyft/formulae/set-simulator-location
brew install macvim
brew install media-info
brew install mobile-shell
brew install mongodb
brew install mono
brew install mysql
brew install neovim
brew install nmap
brew install node
brew install npm
brew install optipng
brew install osx-iso
brew install packer
brew install parallel
brew install pidcat
brew install pngquant
brew install postgresql
brew install q
brew install ripgrep
brew install rbenv rbenv-gemset ruby-build
brew install redis
brew install rlwrap
brew install getsentry/tools/sentry-cli
brew install shellcheck
brew install smartmontools
brew install sshuttle
brew install stunnel
brew install svg2png
brew install terminator
brew install terraform
brew install terraform_landscape
brew install tmux
brew install tree
brew install wget
brew install yarn
brew install zsh zsh-completions zsh-syntax-highlighting zplug

#---------- brew cask packages ----------

# install apps via brew cask
brew cask install 1password
brew cask install adobe-acrobat-reader
brew cask install aerial
brew cask install alacritty
brew cask install alfred
brew cask install android-studio
brew cask install angry-ip-scanner
brew cask install atom
brew cask install balenaetcher
brew cask install beyond-compare
brew cask install bitbar
brew cask install brave
brew cask install calibre
brew cask install chromedriver
brew cask install coconutbattery
brew cask install db-browser-for-sqlite
brew cask install disk-inventory-x
brew cask install divvy
brew cask install docker
brew cask install double-commander
brew cask install etrecheckpro
brew cask install evernote
brew cask install filezilla
brew cask install firefox
brew cask install flux
brew cask install genymotion
brew cask install gimp
brew cask install gitkraken
brew cask install google-backup-and-sync google-drive-file-stream
brew cask install google-cloud-sdk
brew cask install google-nik-collection
brew cask install handbrake
brew cask install hwsensors
brew cask install imageoptim
brew cask install insync
brew cask install intel-haxm
brew cask install istat-menus
brew cask install iterm2
brew cask install jetbrains-toolbox
brew cask install libreoffice
brew cask install macdown
brew cask install microsoft-office
brew cask install minikube
brew cask install mono-mdk
brew cask install ngrok
brew cask install origami-studio
brew cask install outline-manager
brew cask install prime95
brew cask install shadowsocksx-ng
brew cask install sketch
brew cask install sketch-toolbox
brew cask install skype
brew cask install slack
brew cask install sourcetree
brew cask install spectacle
brew cask install sqlitestudio
brew cask install sqlpro-for-sqlite
brew cask install staruml
brew cask install steam
brew cask install sublime-text
brew cask install superduper
brew cask install teamviewer
brew cask install tor-browser
brew cask install tower
brew cask install vagrant
brew cask install virtualbox
brew cask install viscosity
brew cask install visual-studio
brew cask install visual-studio-code
brew cask install vlc
brew cask install vmware-fusion
brew cask install whatsapp
brew cask install wireshark
brew cask install wwdc
brew cask install xamarin
brew cask install xquartz inkscape
brew cask install zeplin

brew cleanup && brew cleanup --prune-prefix

echo "Finished installing brew and brew cask packages successfully."
