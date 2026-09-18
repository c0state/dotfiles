#!/usr/bin/env bash

set -eu

#---------- utils ----------

function exit_with_error {
  echo $1
  exit 1
}

#---------- brew setup ----------

export NONINTERACTIVE=1

if ! which brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# add taps
brew_taps=(
  getsentry/tools
  hashicorp/tap
  domt4/autoupdate
)

for brew_tap in "${brew_taps[@]}"; do
  brew tap $brew_tap 2>&1 | grep -i error >/dev/null && exit_with_error "Could not run brew tap, check your permissions"
  brew trust $brew_tap
done

brew update
brew upgrade --yes

#---------- high level dependencies ----------

echo "---------- Installing core dependencies"

#---------- fonts ----------

brew install font-fira-code font-fira-code-nerd-font
brew install font-jetbrains-mono font-jetbrains-mono-nerd-font

#---------- brew packages ----------

brew_packages=(
  # package dependencies first
  gmp

  7zip
  ack
  act
  ag
  ansible
  aws-iam-authenticator aws-sam-cli eksctl
  awscli
  bash
  bash-completion@2
  bat
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
  fpart
  gh git git-delta git-extras git-filter-repo git-lfs git-secrets lazygit
  glances
  hashicorp/tap/terraform
  helix
  helm
  htop
  imagemagick
  ios-deploy
  jq
  jmeter
  k9s kind kubernetes-cli
  lsd
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
  podman podman-compose
  postgresql@16
  progress
  qt
  ripgrep
  ripgrep-all
  redis
  rlwrap
  rsync
  getsentry/tools/sentry-cli
  selenium-server
  shellcheck
  smartmontools
  sshuttle
  starship
  stunnel
  svg2png
  telnet
  terraform_landscape
  tig
  tmux
  tpack
  tree
  watchman
  wget
  yq
  zsh
)

#---------- brew cask packages ----------

brew_cask_packages=(
  # install apps via brew cask
  1password
  adobe-acrobat-reader
  aerial
  alfred
  android-platform-tools
  antigravity antigravity-cli antigravity-ide
  balenaetcher
  beekeeper-studio
  beyond-compare
  brave-browser
  calibre
  chatgpt
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
  github-copilot-app
  gitkraken
  google-chrome
  google-drive
  google-gemini
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
  obs
  obsidian
  orbstack
  outline-manager
  podman-desktop
  postman
  powershell
  raspberry-pi-imager
  rectangle
  sketch
  slack
  sourcetree
  sqlitestudio
  sqlpro-for-sqlite
  steam
  sublime-text
  superduper
  tabby
  teamviewer
  tor-browser
  tower
  tunnelblick
  utm
  vagrant
  visual-studio-code
  vlc
  warp
  wezterm
  wireshark-app
  xbar
  xquartz inkscape
  zed
  zeplin
  zoom
)

#---------- local skip list ----------
#
# Optional, gitignored file to skip specific packages per machine.
# Applies to both formula and cask lists.

skip_file="$(dirname "$0")/macos_install.local.skip"
skip_list=""
if [[ -r $skip_file ]]; then
  while IFS= read -r line; do
    [[ -z $line ]] && continue
    skip_list="${skip_list}"$'\n'"${line}"
  done <"$skip_file"
fi

is_skipped() {
  local pkg=$1
  [[ -z $skip_list ]] && return 1
  printf '%s\n' "$skip_list" | grep -Fxq -- "$pkg"
}

filter_skipped() {
  local pkg
  local -a out=()
  for pkg in "$@"; do
    if is_skipped "$pkg"; then
      echo "  skipping (in $skip_file): $pkg" >&2
    else
      out+=("$pkg")
    fi
  done
  printf '%s\n' "${out[@]+"${out[@]}"}"
}

# Read filtered output back into arrays (one package per line).
brew_packages_filtered=()
while IFS= read -r line; do
  [[ -n $line ]] && brew_packages_filtered+=("$line")
done < <(filter_skipped "${brew_packages[@]}")

brew_cask_packages_filtered=()
while IFS= read -r line; do
  [[ -n $line ]] && brew_cask_packages_filtered+=("$line")
done < <(filter_skipped "${brew_cask_packages[@]}")

brew_packages=("${brew_packages_filtered[@]+"${brew_packages_filtered[@]}"}")
brew_cask_packages=("${brew_cask_packages_filtered[@]+"${brew_cask_packages_filtered[@]}"}")

echo "---------- Installing brew packages"

for brew_package in "${brew_packages[@]}"; do
  brew list "$brew_package" >/dev/null 2>&1 || brew install "$brew_package"
done

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
