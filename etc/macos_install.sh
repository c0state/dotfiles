#!/usr/bin/env bash

set -eu

PLATFORM=$(uname -s)
MACH_TYPE=$(uname -m)
IS_MACOS_ARM=$(test "$PLATFORM" = "Darwin" && test "$MACH_TYPE" = "arm64" && echo "1" || echo "")

#---------- utils ----------

function exit_with_error {
  echo $1
  exit 1
}

#---------- brew setup ----------

# add taps
brew_taps=(
  hashicorp/tap
  homebrew/autoupdate
  wix/brew
)

for brew_tap in "${brew_taps[@]}"; do
  brew tap $brew_tap 2>&1 | grep -i error >/dev/null && exit_with_error "Could not run brew tap, check your permissions"
done

brew update
brew upgrade

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

#---------- fonts ----------

brew install --cask font-fira-code

#---------- brew packages ----------

brew_packages=(
    # package dependencies first
    gmp 
    
    7zip
    ack
    act
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
    colima
    colordiff icdiff
    coreutils
    dive
    ddrescue
    direnv
    dnsmasq
    dos2unix
    eza
    exiftool
    fd
    ffmpeg
    findutils
    fish
    fnm
    gh git git-delta git-extras git-lfs git-secrets lazygit legit
    glances
    harelba/q/q
    hashicorp/tap/terraform
    helix
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
    mas
    media-info
    minicom
    minikube
    mkcert
    mobile-shell
    mysql
    ncdu
    neovim
    nmap
    nnn
    nushell
    openjdk
    openssl
    optipng
    packer
    parallel
    pgcli
    pidcat
    pkg-config
    pngquant
    podman podman-desktop podman-compose
    postgresql@16
    progress
    qt
    ripgrep
    ripgrep-all
    redis
    rlwrap
    getsentry/tools/sentry-cli
    selenium-server
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
    chatgpt chatgpt-atlas
    chromedriver
    claude
    coconutbattery
    cursor
    db-browser-for-sqlite
    dbeaver-community
    discord
    docker
    dotnet-sdk
    evernote
    firefox
    flutter
    flux
    font-hack-nerd-font
    ghostty
    gimp
    git-credential-manager
    github
    gitkraken
    google-chrome
    google-drive
    graphql-playground
    handbrake
    headlamp
    imageoptim
    insomnia
    istat-menus
    iterm2
    itsycal
    jetbrains-toolbox
    kitty
    lens openlens
    libreoffice
    microsoft-edge
    microsoft-office
    microsoft-teams
    ngrok
    obs obs-ndi
    obsidian
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
    wezterm
    whatsapp
    wireshark
    xbar
    xquartz inkscape
    zed
    zeplin
    zoom
)

echo "---------- Installing brew cask packages"

for brew_cask_package in "${brew_cask_packages[@]}"; do
    brew list --cask "$brew_cask_package" >/dev/null 2>&1 || brew install --cask "$brew_cask_package"
done

brew completions link

#---------- Configure auto updater ----------

brew autoupdate delete && brew autoupdate start --cleanup

#---------- Cleanup ----------

echo "---------- Running cleanup"

brew cleanup
rm -rf "$(brew --cache)"

echo "---------- Finished installing brew and brew cask packages successfully."
