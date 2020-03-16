#!/usr/bin/env bash

#---------- brew setup ----------

# exit on any failed command
set -e

# add taps
brew tap aws/tap
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap busterc/tap

brew update && brew upgrade && brew cask upgrade

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

# need to install items from the app store
brew list mas >/dev/null 2>&1 || brew install mas
# java is needed for some apps
brew cask list java >/dev/null 2>&1 || brew cask install java

#---------- brew packages ----------

brew_packages=(
    # package dependencies first
    gmp 
    
    ack
    ag
    aws-iam-authenticator aws-sam-cli
    bash-completion@2
    bfg
    boost
    carthage
    circleci
    cmake
    cocoapods
    colordiff icdiff
    coreutils
    ddrescue
    direnv
    dnsmasq
    dos2unix
    exiftool
    fd
    ffmpeg
    findutils
    fzf
    git git-extras git-lfs legit
    github/gh/gh
    glances
    go
    htop
    hub
    imagemagick
    TomAnthony/brews/itermocil
    jq
    kubernetes-cli
    lsd
    lyft/formulae/set-simulator-location
    macvim
    media-info
    minikube
    mobile-shell
    mono
    mysql
    neovim
    nmap
    nnn
    node
    npm
    openssl openssl@1.1
    optipng
    osx-iso
    packer
    parallel
    pidcat
    pngquant
    postgresql
    pre-commit
    q
    qt
    ripgrep
    rbenv rbenv-gemset ruby-build
    redis
    rlwrap
    getsentry/tools/sentry-cli
    sd
    shellcheck
    smartmontools
    sshuttle
    stunnel
    svg2png
    terraform
    terraform_landscape
    tmux
    tree
    wget
    yarn
    zsh zsh-completions zsh-syntax-highlighting
)

echo "---------- Installing brew packages"

for brew_package in "${brew_packages[@]}"; do
    brew list "$brew_package" >/dev/null 2>&1 || brew install "$brew_package"
done

#---------- brew cask packages ----------

brew_cask_packages=(
    # install apps via brew cask
    1password
    adobe-acrobat-reader
    aerial
    alacritty
    alfred
    angry-ip-scanner
    atom
    balenaetcher
    beyond-compare
    bitbar
    brave-browser
    calibre
    chromedriver
    coconutbattery
    db-browser-for-sqlite
    divvy
    docker
    dotnet-sdk
    double-commander
    etrecheckpro
    evernote
    firefox
    flux
    font-hack-nerd-font
    genymotion
    gimp
    gitkraken
    google-backup-and-sync google-drive-file-stream
    google-cloud-sdk
    google-nik-collection
    graphql-playground
    handbrake
    hwsensors
    imageoptim
    insync
    intel-haxm
    istat-menus
    iterm2
    jetbrains-toolbox
    libreoffice
    macdown
    microsoft-edge
    mono-mdk
    ngrok
    origami-studio
    outline-manager
    postman
    powershell
    # prime95 cask seems to have disappeared?
    # prime95
    selenium-server-standalone
    send-to-kindle
    sketch
    sketch-toolbox
    skype
    slack
    sourcetree
    spectacle
    sqlitestudio
    sqlpro-for-sqlite
    staruml
    steam
    sublime-text
    superduper
    teamviewer
    tor-browser
    tower
    vagrant
    virtualbox
    viscosity
    visual-studio visual-studio-code visual-studio-code-insiders
    vlc
    whatsapp
    wireshark
    xamarin
    xquartz inkscape
    zeplin
)

echo "---------- Installing brew cask packages"

for brew_cask_package in "${brew_cask_packages[@]}"; do
    brew cask list "$brew_cask_package" >/dev/null 2>&1 || brew cask install "$brew_cask_package"
done

#---------- Cleanup ----------

echo "---------- Running cleanup"

brew cleanup && brew cleanup --prune-prefix

echo "---------- Finished installing brew and brew cask packages successfully."
