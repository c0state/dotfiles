#!/usr/bin/env bash

set -eu

IS_WSL=$(uname -a | grep -i microsoft || echo "")
DPKG_ARCH=$(dpkg --print-architecture 2>/dev/null || echo "")

# init vscode
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f /tmp/packages.microsoft.gpg

# init github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# init tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# tabby
curl -fsSL https://packagecloud.io/eugeny/tabby/gpgkey | sudo gpg --dearmor --yes -o /etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg] https://packagecloud.io/eugeny/tabby/ubuntu kinetic main" | sudo tee /etc/apt/sources.list.d/eugeny_tabby.list
echo "deb-src [signed-by=/etc/apt/keyrings/eugeny_tabby-archive-keyring.gpg] https://packagecloud.io/eugeny/tabby/ubuntu kinetic main" | sudo tee -a /etc/apt/sources.list.d/eugeny_tabby.list

# lens
curl -fsSL https://downloads.k8slens.dev/keys/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/lens-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | \
  sudo tee /etc/apt/sources.list.d/lens.list > /dev/null

#------------------------------ ppas

(ls /etc/apt/sources.list.d/alessandro-strada*) || sudo add-apt-repository -y ppa:alessandro-strada/ppa
(ls /etc/apt/sources.list.d/fish-shell-ubuntu-release*) || sudo apt-add-repository -y ppa:fish-shell/release-3
(ls /etc/apt/sources.list.d/touchegg*) || sudo add-apt-repository -y ppa:touchegg/stable

#------------------------------ begin update and installs

sudo apt-get update

#------------------------------ install core packages

sudo apt -y install \
    flatpak \
    snapd

#------------------------------ install utility packages

sudo apt -y install \
    bat \
    colordiff icdiff \
    curl wget \
    direnv \
    dos2unix \
    fd-find \
    git git-lfs \
    glances \
    gparted \
    gnome-tweaks \
    gnupg gpg ca-certificates \
    google-drive-ocamlfuse \
    keychain \
    lsd \
    ncdu \
    nethogs \
    obs-studio \
    parallel \
    ranger \
    ripgrep \
    tabby-terminal \
    tree \
    wireshark \
    wmctrl \
    vim-nox

#------------------------------ install packages

sudo snap install slack
sudo snap refresh

#------------------------------ flatpak repos

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install --system -y touche

#------------------------------ install packages

# install compiler packages
sudo apt -y install \
    build-essential cmake \
    zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libssl-dev llvm \
    libncurses5-dev libncursesw5-dev \
    libxml2-dev

# install docker and set up group
sudo apt-get -y install \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd --force docker
sudo usermod -aG docker $USER

# only available on pop os out of the box
sudo apt -y install alacritty || true

# install developer packages
sudo apt -y install \
    fonts-firacode \
    gh \
    lens \
    tmux \
    vagrant

# ---------- set up lsd ls replacement

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | command grep -Po '"tag_name": "v\K[^"]*')
curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | \
    tar -xzO lazygit \
    > "$HOME"/.local/bin/lazygit && chmod ug+x "$HOME"/.local/bin/lazygit

which jetbrains-toolbox || \
    wget -O - https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.3.14493.tar.gz | \
        tar -xzO jetbrains-toolbox-1.27.3.14493/jetbrains-toolbox \
    > "$HOME"/.local/bin/jetbrains-toolbox && \
    chmod u+x "$HOME"/.local/bin/jetbrains-toolbox

if ! which nvim > /dev/null; then
    wget https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage -O "$HOME"/.local/bin/nvim
    chmod +x "$HOME"/.local/bin/nvim
fi

if ! which lvim > /dev/null; then
    LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh) -- --no-install-dependencies
fi

# install vscode
[ -z $IS_WSL ] && sudo apt install code

# install browsers
sudo apt install fonts-liberation

# chrome isn't in core repos for ubuntu
if ! which google-chrome-stable; then
    bash -i -c "install_package https://dl.google.com/linux/direct/google-chrome-stable_current_$DPKG_ARCH.deb"
else
    sudo apt install -y google-chrome-stable
fi

# install image packages
sudo apt -y install \
    ffmpeg imagemagick pngquant

# install java packages
sudo apt -y install \
    default-jdk

# install networking packages
sudo apt -y install avahi-daemon samba \
    tailscale \
    winbind

# install db packages
sudo apt -y install libpq-dev postgresql-client

# install python packages
sudo apt -y install \
    python3-dev python3-pip python3-venv python-is-python3

# install ruby packages
sudo apt -y install \
    ruby-dev

# install shell packages
sudo apt -y install \
    fish \
    zsh zsh-doc

sudo apt install -y touchegg

echo "--------------------------------------------------"
echo "Successfully installed all Linux packages!"
echo "--------------------------------------------------"

