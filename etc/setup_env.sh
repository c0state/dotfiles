#!/usr/bin/env bash

set -ex

# ---------- set up dotfiles links

DOTFILES=".bash_functions .bash_profile .bashrc .dircolors .editorconfig .gitconfig-base .gitignore .gitignore_global .ideavimrc .inputrc .itermocil .mrxvtrc .oh-my-zsh-custom .profile .screenrc .shell_aliases .shell_functions .shellrc .studioforkdb .tmux.conf .toprc .vimrc .vscode .xemacs .zlogin .zsh_functions .zshrc"

for FILE in $DOTFILES; do
    echo processing $FILE
    ln -s -f $HOME/.dotfiles/$FILE $HOME/
done

mkdir -p $HOME/.config
(ln -s $HOME/.dotfiles/.config/* $HOME/.config || /bin/true)

if [[ ! -d $HOME/etc ]]; then
    ln -s $HOME/.dotfiles/etc $HOME/
fi

# ---------- set up prompt

if ! which starship; then
    curl -fsSL https://raw.githubusercontent.com/starship/starship/master/install/install.sh | bash -s -- --force
    mkdir -p $HOME/.config
    ln -s "$(which starship)" $HOME/.config
fi

# ---------- set up ohmyzsh

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc
fi

# ---------- set up vim plugins

# TODO: fix
# vim +PlugUpdate +PlugUpgrade +qall

# ---------- set up lsd ls replacement

# TODO: add
#if ! $(which lsd > /dev/null); then
#    install_package "https://github.com/Peltoche/lsd/releases/download/-4.19.0/lsd_0.19.0_amd64.deb"
#fi
