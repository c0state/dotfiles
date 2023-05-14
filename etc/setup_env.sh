#!/usr/bin/env bash

set -eux

# ---------- shared variables

PLATFORM_FULL=$(uname -a)
PLATFORM=$(echo "$PLATFORM_FULL" | cut -d ' ' -f 1)
IS_WSL=$(echo "$PLATFORM_FULL" | grep -i microsoft || echo "")

# ---------- set up dotfiles links

if [[ ! -d /usr/local/bin ]]; then
    sudo mkdir /usr/local/bin
    sudo chown "$USER" /usr/local/bin
    sudo chgrp staff /usr/local/bin
fi

mkdir -p "$HOME"/.local/bin

DOTFILES=".bash_functions .bash_profile .bashrc .editorconfig .gitconfig-base .gdbinit .ideavimrc .mrxvtrc .oh-my-zsh-custom .screenrc .shell_aliases .shell_aliases.fish .shell_functions .shell_functions.fish .shell_interactive.sh .studioforkdb .tmux.conf .toprc .vimrc .zsh_functions .zshrc"

for FILE in $DOTFILES; do
    echo processing "$FILE"
    ln -s -f "$HOME"/.dotfiles/"$FILE" "$HOME"/
done

mkdir -p "$HOME"/.config
(ln -s "$HOME"/.dotfiles/.config/* "$HOME"/.config || true)

if [[ ! -d $HOME/etc ]]; then
    ln -s "$HOME"/.dotfiles/etc "$HOME"/
fi

# ---------- set up gitconfig

if [[ -n "$IS_WSL" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-linux "$HOME"/.gitconfig-linux
    ln -s -f "$HOME"/.dotfiles/.gitconfig-wsl "$HOME"/.gitconfig
elif [[ "$PLATFORM" == "Linux" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-linux "$HOME"/.gitconfig
elif [[ "$PLATFORM" == "Darwin" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-macos "$HOME"/.gitconfig
fi

# ---------- set up prompt

curl -fsSL https://raw.githubusercontent.com/starship/starship/master/install/install.sh | sh -s -- --yes --bin-dir "$HOME"/.local/bin

# ---------- set up ohmyzsh

if [[ ! -d $HOME/.oh-my-zsh ]]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc
else
    (cd "$HOME"/.oh-my-zsh && git pull)
fi

# ---------- set up vim plugins

vim +PlugUpdate +PlugUpgrade +UpdateRemotePlugins +qall

# ---------- set up lunarvim

if ! which lvim > /dev/null; then
    LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh) -- --no-install-dependencies
else
    lvim +LvimUpdate +qall
fi

# ---------- set up fzf https://github.com/junegunn/fzf

if [[ ! -d $HOME/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
fi
cd "$HOME"/.fzf && git pull && "$HOME"/.fzf/install --key-bindings --completion --no-update-rc

# ---------- set up tpm https://github.com/tmux-plugins/tpm

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
else
    (cd "$HOME"/.tmux/plugins/tpm && git pull)
fi
"$HOME"/.tmux/plugins/tpm/bin/install_plugins

# ---------- git sub-repo

if [[ ! -d $HOME/.git-subrepo ]]; then
    git clone https://github.com/ingydotnet/git-subrepo.git "$HOME"/.git-subrepo
else
    (cd "$HOME"/.git-subrepo && git pull)
fi

# ---------- bit https://github.com/chriswalz/bit

(
    # bit installed via brew on macOS
    if [[ "$PLATFORM" != "Darwin" ]]; then
        curl -sf https://gobinaries.com/chriswalz/bit | PREFIX=$HOME/.local/bin sh
    fi
)

# ---------- fast node manager https://github.com/Schniz/fnm

if [[ "$PLATFORM" != "Darwin" ]]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

# ---------- krew https://krew.sigs.k8s.io/docs/user-guide

if [[ ! -d $HOME/.krew ]]; then
    (
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
    )
fi

# ---------- nix

if ! which nix >/dev/null ; then
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
fi

# ---------- google cloud sdk

if ! which gcloud; then
    curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir "$HOME"/.local
else
    gcloud components update --quiet
fi

#---------- containers ----------

if [[ "$PLATFORM" == "Darwin" ]]; then
    colima start --runtime docker
    colima nerdctl install --path "$HOME"/.local/bin/nerdctl
fi

# ---------- updates

"$HOME"/etc/update_dotfiles.sh

"$HOME"/etc/dotnet.sh
"$HOME"/etc/golang.sh
"$HOME"/etc/js_tools.sh
"$HOME"/etc/python.sh
"$HOME"/etc/ruby.sh
"$HOME"/etc/rust.sh

"$HOME"/etc/setup_kubernetes.sh

echo "Successfully run setup!"
