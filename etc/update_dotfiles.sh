#!/usr/bin/env bash

#---------- update dotfiles folder

(cd "$HOME"/.dotfiles && git pullr --all)
(cd "$HOME"/.dotfiles && git submodule update --init --recursive --remote)

#---------- update deno

if command -v deno >/dev/null; then
    deno upgrade
    deno completions zsh > "$HOME"/.oh-my-zsh-custom/plugins/deno/_deno
fi

if command -v bit >/dev/null; then
    bit update
fi
