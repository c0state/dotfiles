#!/usr/bin/env bash

set -eux

# ---------- shared variables

PLATFORM_FULL=$(uname -a)
PLATFORM=$(uname)
WSL_DISTRO_NAME=${WSL_DISTRO_NAME:-""}

# ---------- set up dotfiles links

if [[ ! -d /usr/local/bin ]]; then
    sudo mkdir /usr/local/bin
    sudo chown "$USER" /usr/local/bin
    sudo chgrp staff /usr/local/bin
fi

mkdir -p "$HOME"/.local/bin

DOTFILES=".bash_functions .bash_profile .bashrc .editorconfig .gitconfig-base .gdbinit .mrxvtrc .oh-my-zsh-custom .screenrc .shell_aliases .shell_functions .shell_functions.fish .shell_interactive.sh .studioforkdb .tmux.conf .toprc .wezterm.lua .zsh_functions .zshrc"

for FILE in $DOTFILES; do
    echo processing "$FILE"
    ln -s -f -n "$HOME"/.dotfiles/"$FILE" "$HOME"/"$FILE"
done

mkdir -p "$HOME"/.config
(ln -s "$HOME"/.dotfiles/.config/* "$HOME"/.config || true)

if [[ ! -d $HOME/etc ]]; then
    ln -s "$HOME"/.dotfiles/etc "$HOME"/
fi

# ---------- set up gitconfig

if [[ -n "$WSL_DISTRO_NAME" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-wsl "$HOME"/.gitconfig
elif [[ "$PLATFORM" == "Linux" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-linux "$HOME"/.gitconfig
elif [[ "$PLATFORM" == "Darwin" ]]; then
    ln -s -f "$HOME"/.dotfiles/.gitconfig-macos "$HOME"/.gitconfig
fi
curl -fsSL https://raw.githubusercontent.com/dandavison/delta/refs/heads/main/themes.gitconfig -o "$HOME"/.gitconfig-delta.themes.gitconfig

# ---------- set up prompt

curl -fsSL https://raw.githubusercontent.com/starship/starship/master/install/install.sh | sh -s -- --yes --bin-dir "$HOME"/.local/bin

# ---------- set up ohmyzsh

if [[ ! -d $HOME/.oh-my-zsh ]]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc
else
    (cd "$HOME"/.oh-my-zsh && git pull)
fi

# ---------- set up nvchad

nvim --headless "+Lazy! sync" +qa

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
"$HOME"/.tmux/plugins/tpm/bin/update_plugins all

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

# ---------- mise

export MISE_GITHUB_TOKEN=${GITHUB_TOKEN_SCRIPTS:-""}

if ! which mise >/dev/null ; then
    curl https://mise.run | sh
else
    mise self-update --yes
fi

# ---------- nix

if ! which nix >/dev/null ; then
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
fi

# ---------- github cli

if gh auth status; then
  gh extension upgrade --all
fi

# ---------- claude

if [[ -f "$HOME/Library/Application Support/Claude/claude_desktop_config.json" ]]; then
  ln -f -s "$HOME/.dotfiles/osx_configs/claude_desktop_config.json" "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
fi

# ---------- google cloud sdk

if ! which gcloud; then
    curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir "$HOME"/.local
else
    gcloud components update --quiet
fi

#---------- containers ----------

if [[ "$PLATFORM" == "Darwin" ]]; then
    # using docker or podman desktop for now as colima is a bit limiting (eg: x86 support)
    # but keeping it for nerdctl
    #colima start --runtime docker
    colima nerdctl install --path "$HOME"/.local/bin/nerdctl --force
fi

# ---------- updates

"$HOME"/etc/update_dotfiles.sh

"$HOME"/etc/dotnet.sh
"$HOME"/etc/golang.sh
"$HOME"/etc/haskell.sh
"$HOME"/etc/js_tools.sh
"$HOME"/etc/python.sh
"$HOME"/etc/ruby.sh
"$HOME"/etc/rust.sh

"$HOME"/etc/setup_kubernetes.sh
"$HOME"/etc/setup_env.fish

if [[ "$PLATFORM" == "Linux" ]]; then
  "$HOME"/etc/linux_tools.sh
fi

# ---------- cleanup

# remove dead symlinks
find "$HOME"/.local/bin/ -xtype l -delete

echo "Successfully run setup!"
