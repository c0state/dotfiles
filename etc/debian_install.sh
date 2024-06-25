#!/usr/bin/env -S bash -i

set -eu

WSL_DISTRO_NAME=${WSL_DISTRO_NAME:-""}

#------------------------------ install core utils

sudo apt update
sudo apt -y install curl

# install shell packages
sudo apt -y install \
    fish \
    zsh zsh-doc

#------------------------------ install package sources

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

# lens
curl -fsSL https://downloads.k8slens.dev/keys/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/lens-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | \
  sudo tee /etc/apt/sources.list.d/lens.list > /dev/null

# onedrive
wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_23.10/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/onedrive.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_23.10/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list

curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_23.10/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/onedriver_jstaf.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/onedriver_jstaf.gpg] http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_23.10/ /" | sudo tee /etc/apt/sources.list.d/onedriver_jstaf.list

# signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-desktop.list

#------------------------------ ppas

(ls /etc/apt/sources.list.d/alessandro-strada*) || sudo add-apt-repository -y ppa:alessandro-strada/ppa
(ls /etc/apt/sources.list.d/fish-shell-ubuntu-release*) || sudo apt-add-repository -y ppa:fish-shell/release-3

#------------------------------ install core packages

sudo apt update

sudo apt -y install \
    flatpak \
    snapd

#------------------------------ install utility packages

sudo apt -y install \
    bat \
    colordiff icdiff \
    wget \
    direnv \
    dos2unix \
    fd-find \
    git git-lfs \
    glances \
    gparted \
    gnome-browser-connector gnome-tweaks \
    gnupg gpg ca-certificates \
    google-drive-ocamlfuse \
    keychain \
    lsd \
    ncdu \
    nethogs \
    onedrive onedriver \
    parallel \
    putty \
    ranger \
    ripgrep \
    tree \
    wireshark \
    wmctrl \
    vim-nox

#------------------------------ install packages

sudo snap install firefox
sudo snap install slack
sudo snap refresh

#------------------------------ flatpak repos

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user -y flathub io.podman_desktop.PodmanDesktop
flatpak install --user -y flathub com.obsproject.Studio
sudo flatpak update -y

#------------------------------ general init

mkdir -p "$HOME"/.local/bin

#------------------------------ install packages

# install compiler packages
sudo apt -y install \
    build-essential cmake \
    zlib1g-dev \
    libbz2-dev liblzma-dev \
    libreadline-dev libsqlite3-dev libssl-dev llvm \
    libncurses5-dev libncursesw5-dev \
    libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev \
    libxml2-dev \
    tk-dev

# install docker and set up group
sudo apt -y install \
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
    tmux

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | command grep -Po '"tag_name": "v\K[^"]*')
curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | \
    tar -xzO lazygit \
    > "$HOME"/.local/bin/lazygit && chmod ug+x "$HOME"/.local/bin/lazygit

OPENLENS_VERSION=$(curl -s "https://api.github.com/repos/MuhammedKalkan/OpenLens/releases/latest" | command grep -Po '"tag_name": "v\K[^"]*')
install_package "https://github.com/MuhammedKalkan/OpenLens/releases/latest/download/OpenLens-$OPENLENS_VERSION.$DPKG_ARCH.deb"

GIT_CRED_MGR_VERSION=$(curl -s "https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest" | command grep -Po '"tag_name": "v\K[^"]*')
install_package "https://github.com/git-ecosystem/git-credential-manager/releases/latest/download/gcm-linux_$DPKG_ARCH.$GIT_CRED_MGR_VERSION.deb"

which jetbrains-toolbox || \
    wget -O - https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.3.14493.tar.gz | \
        tar -xzO jetbrains-toolbox-1.27.3.14493/jetbrains-toolbox \
    > "$HOME"/.local/bin/jetbrains-toolbox && \
    chmod u+x "$HOME"/.local/bin/jetbrains-toolbox

if ! which nvim > /dev/null; then
    wget https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage -O "$HOME"/.local/bin/nvim
    chmod +x "$HOME"/.local/bin/nvim
fi

# install vscode
[ -z "$WSL_DISTRO_NAME" ] && sudo apt install code

# install apps
sudo apt -y install \
  google-chrome-stable \
  signal-desktop \
  vlc

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

echo "--------------------------------------------------"
echo "Successfully installed all Linux packages!"
echo "--------------------------------------------------"
