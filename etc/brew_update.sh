#!/usr/bin/env bash

#---------- check python version

if ! pyenv version | grep system; then
    echo "Change to system python when running this script"
    exit 1
fi

#---------- brew setup ----------

# exit on any failed command
set -eu

# add taps
brew tap aws/tap
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap busterc/tap
brew tap melonamin/formulae
brew tap wix/brew

brew update && brew upgrade && brew upgrade --cask

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

# need to install items from the app store
brew list mas >/dev/null 2>&1 || brew install mas
# java is needed for some apps
brew list --cask java >/dev/null 2>&1 || brew install --cask java

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
    blast
    boost
    carthage
    circleci
    cmake
    cocoapods
    colordiff icdiff
    coreutils
    dive
    ddrescue
    direnv
    dnsmasq
    dos2unix
    exa
    exiftool
    fd
    ffmpeg
    findutils
    fish
    fzf
    git git-extras git-lfs legit
    github/gh/gh
    glances
    htop
    hub
    imagemagick
    ios-deploy
    TomAnthony/brews/itermocil
    jq
    k9s
    kubernetes-cli
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
    node
    npm
    openssl
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
    swiftbar
    telnet
    terraform
    terraform_landscape
    tmux
    tree
    watchman
    wget
    yarn
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
    # needed as most tools look for SDK in known path
    android-studio
    angry-ip-scanner
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
    evernote
    firefox
    flutter
    flux
    font-hack-nerd-font
    genymotion
    gimp
    github
    gitkraken
    google-backup-and-sync google-drive
    google-cloud-sdk
    google-nik-collection
    graphql-playground
    handbrake
    hwsensors
    imageoptim
    insomnia
    intel-haxm
    istat-menus
    iterm2
    itsycal
    jetbrains-toolbox
    lens
    libreoffice
    microsoft-edge
    ngrok
    obs
    outline-manager
    postman
    powershell
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
    vagrant
    virtualbox
    visual-studio-code
    vlc
    whatsapp
    wireshark
    xquartz inkscape
    zeplin
)

echo "---------- Installing brew cask packages"

for brew_cask_package in "${brew_cask_packages[@]}"; do
    brew list --cask "$brew_cask_package" >/dev/null 2>&1 || brew install --cask "$brew_cask_package"
done

brew completions link

#---------- Cleanup ----------

echo "---------- Running cleanup"

brew cleanup
rm -rf "$(brew --cache)"

echo "---------- Finished installing brew and brew cask packages successfully."
