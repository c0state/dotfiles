#!/usr/bin/env bash

set -ex

# ---------- shared variables

PLATFORM=$(uname)

# ---------- set up dotfiles links

DOTFILES=".bash_functions .bash_profile .bashrc .editorconfig .gitconfig-base .gitignore .gitignore_global .ideavimrc .inputrc .itermocil .mrxvtrc .oh-my-zsh-custom .screenrc .shell_aliases .shell_aliases.fish .shell_functions .shell_interactive .studioforkdb .tmux.conf .toprc .vimrc .xemacs .zsh_functions .zshrc"

for FILE in $DOTFILES; do
    echo processing "$FILE"
    ln -s -f "$HOME"/.dotfiles/"$FILE" "$HOME"/
done

mkdir -p "$HOME"/.config
(ln -s "$HOME"/.dotfiles/.config/* "$HOME"/.config || true)

if [[ ! -d $HOME/etc ]]; then
    ln -s "$HOME"/.dotfiles/etc "$HOME"/
fi

# ---------- set up prompt

if ! which starship; then
    curl -fsSL https://raw.githubusercontent.com/starship/starship/master/install/install.sh | bash -s -- --force
    mkdir -p "$HOME"/.config
    ln -s "$(which starship)" "$HOME"/.config
fi

# ---------- set up ohmyzsh

if [[ ! -d $HOME/.oh-my-zsh ]]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc
fi

# ---------- set up vim plugins

# TODO: hangs when run in test script
# vim +PlugUpdate +PlugUpgrade +qall

# ---------- set up lsd ls replacement

if ! which lsd > /dev/null && [[ "$PLATFORM" == "Linux" ]]; then
    bash -i -c "install_package https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb"
fi

# ---------- set up dive https://github.com/wagoodman/dive

if ! which dive > /dev/null && [[ "$PLATFORM" == "Linux" ]]; then
    bash -i -c "install_package https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb"
fi

# ---------- set up fzf https://github.com/junegunn/fzf

if [[ ! -d $HOME/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    "$HOME"/.fzf/install --key-bindings --completion --no-update-rc
fi

# ---------- set up tpm https://github.com/tmux-plugins/tpm

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
    "$HOME"/.tmux/plugins/tpm/bin/install_plugins
fi

# ---------- git sub-repo

if [[ ! -d $HOME/.git-subrepo ]]; then
    git clone https://github.com/ingydotnet/git-subrepo.git "$HOME"/.git-subrepo
fi

# ---------- bit https://github.com/chriswalz/bit

if ! which bit; then
    curl -sf https://gobinaries.com/chriswalz/bit | sh
fi

# ---------- update dotfiles

"$HOME"/etc/update_dotfiles.sh

