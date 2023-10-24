#!/usr/bin/env bash

# import divvy keyboard shortcuts
open -a Safari "$(cat ~/.dotfiles/osx_configs/divvy_export.txt)"

curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz \
    | tar zxvf - -C "$HOME"/Library/Fonts  
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
    | tar zxvf - -C "$HOME"/Library/Fonts  
