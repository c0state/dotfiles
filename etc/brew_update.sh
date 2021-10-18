#!/usr/bin/env bash

set -eu

IS_MACOS_ARM=$(uname -a | grep -i "darwin.*arm64" || echo "")

#---------- check python version

if ! pyenv version | grep system; then
    echo "Change to system python when running this script"
    exit 1
fi

#---------- brew setup ----------

# add taps
brew tap aws/tap
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap wix/brew

brew update && brew upgrade && brew upgrade --cask

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

# need to install items from the app store
brew list mas >/dev/null 2>&1 || brew install mas
# java is needed for some apps
brew install openjdk

#---------- brew packages ----------

brew_packages=(
    # package dependencies first
    gmp 
    
    ack
    ag
    applesimutils
    aws-iam-authenticator aws-sam-cli
    awscli
    bash-completion@2
    bat
    bfg
# no arm version   blast
    boost cmake # no arm version gdb
    carthage
# no arm version  circleci
    cocoapods
    colordiff icdiff
    coreutils
    dive
    ddrescue
    direnv
    dnsmasq
    docker-completion docker-compose-completion
    dos2unix
    exa
    exiftool
    fd
    ffmpeg
    findutils
    fish
    fzf
    gh git git-delta git-extras git-lfs legit
    glances
    htop
    hub
    imagemagick
    ios-deploy
    jq
    k9s kind kubernetes-cli
    lsd
    lyft/formulae/set-simulator-location
    macvim
    media-info
    minikube
    mobile-shell
    mysql
    neovim
    nmap
    nnn
    openssl
    optipng
    packer
    parallel
    pidcat
    pngquant
    postgresql
    progress
    q
    qt
    ripgrep
    redis
    rlwrap
    getsentry/tools/sentry-cli
    selenium-server-standalone
    shellcheck
    smartmontools
    sshuttle
    starship
    stunnel
    svg2png
    telnet
    terraform
    terraform_landscape
    tmux
    tree
    watchman
    wget
    yq
    zsh
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
    amorphousdiskmark
    angry-ip-scanner
    balenaetcher
    beyond-compare
    brave-browser
    calibre
    chromedriver
    coconutbattery
    db-browser-for-sqlite
    discord
    divvy
    docker
    dotnet-sdk
    evernote
    firefox
    flutter
    flux
    font-hack-nerd-font
    genymotion
    gimp
    github
    gitkraken
    google-chrome
    google-cloud-sdk
    google-drive
    graphql-playground
    handbrake
    hwsensors
    imageoptim
    insomnia
    istat-menus
    iterm2
    itsycal
    jetbrains-toolbox
    lens
    libreoffice
    microsoft-edge
    ngrok
    obs obs-ndi
    outline-manager
    postman
    powershell
    raspberry-pi-imager
    rectangle
    signal
    sketch
    skype
    slack
    sourcetree
    spectacle
    sqlitestudio
    sqlpro-for-sqlite
    steam
    sublime-text
    superduper
    teamviewer
    tor-browser
    tower
    utm
    vagrant
    virtualbox
    visual-studio-code
    vlc
    whatsapp
    wireshark
    xbar
    xquartz inkscape
    zeplin
    zoom
)

echo "---------- Installing brew cask packages"

for brew_cask_package in "${brew_cask_packages[@]}"; do
    brew list --cask "$brew_cask_package" >/dev/null 2>&1 || brew install --cask "$brew_cask_package"
done

brew completions link

#---------- Intel only packages ----------

if [[ -z IS_MACOS_ARM ]]; then
    brew install --cask intel-haxm
fi

#---------- Cleanup ----------

echo "---------- Running cleanup"

brew cleanup
rm -rf "$(brew --cache)"

echo "---------- Finished installing brew and brew cask packages successfully."
