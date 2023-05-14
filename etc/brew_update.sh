#!/usr/bin/env bash

set -eu

IS_MACOS_ARM=$(uname -a | grep -i "darwin.*arm64" || echo "")

#---------- brew setup ----------

# add taps
brew tap aws/tap
brew tap homebrew/autoupdate
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap wix/brew

brew update && brew upgrade

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

# need to install items from the app store
brew list mas >/dev/null 2>&1 || brew install mas
# java is needed for some apps
brew install openjdk

#---------- fonts ----------

brew install --cask font-fira-code

#---------- brew packages ----------

brew_packages=(
    # package dependencies first
    gmp 
    
    ack
    ag
    android-platform-tools
    applesimutils
    aws-iam-authenticator aws-sam-cli eksctl
    awscli
    bash-completion@2
    bat
    bfg
    bit-git
    blast
    boost cmake
    carthage
    circleci
    cocoapods
    colordiff icdiff
    coreutils
    dive
    ddrescue
    direnv
    dnsmasq
    docker
    dos2unix
    exa
    exiftool
    fd
    ffmpeg
    findutils
    fish
    fnm
    fzf
    gh git git-delta git-extras git-lfs lazygit legit
    glances
    helm
    htop
    hub
    imagemagick
    ios-deploy
    jq
    jmeter
    k9s kind kubernetes-cli
    lsd
    lyft/formulae/set-simulator-location
    macvim
    media-info
    minikube
    mobile-shell
    mysql
    ncdu
    neovim
    nmap
    nnn
    octant
    openssl
    optipng
    packer
    parallel
    pidcat
    pngquant
    podman podman-desktop podman-compose
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

if [[ -z $IS_MACOS_ARM ]]; then
    brew_packages+=(hyperkit)
fi

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
    beekeeper-studio
    beyond-compare
    brave-browser
    calibre
    chromedriver
    coconutbattery
    db-browser-for-sqlite
    discord
    divvy
    dotnet-sdk
    evernote
    firefox
    flutter
    flux
    font-hack-nerd-font
    gimp
    github
    gitkraken
    google-chrome
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
    kitty
    lens openlens headlamp
    libreoffice
    microsoft-edge
    microsoft-office
    ngrok
    obs obs-ndi
    outline-manager
    postman
    powershell
    raspberry-pi-imager
    rectangle
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
    tabby
    teamviewer
    tor-browser
    tower
    utm
    vagrant
    visual-studio-code
    vlc
    warp
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

#---------- containers ----------

brew install colima
colima start --runtime containerd
colima nerdctl install --path "$HOME"/.local/bin/nerdctl

#---------- Intel only packages ----------

if [[ -z $IS_MACOS_ARM ]]; then
    brew install --cask intel-haxm
fi

#---------- Configure auto updater ----------

brew autoupdate delete && brew autoupdate start --cleanup

#---------- Cleanup ----------

echo "---------- Running cleanup"

brew cleanup
rm -rf "$(brew --cache)"

echo "---------- Finished installing brew and brew cask packages successfully."
