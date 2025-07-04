#!/usr/bin/env bash

# TODO: consolidate into setup_env.sh

#---------- vars

if [ -n "$GITHUB_TOKEN_SCRIPTS" ]; then
  export GITHUB_TOKEN="$GITHUB_TOKEN_SCRIPTS"
fi

#---------- update dotfiles folder

(cd "$HOME"/.dotfiles && git pullr --all)
(cd "$HOME"/.dotfiles && git submodule update --init --recursive --remote)
(cd "$HOME"/.dotfiles && git submodule foreach git pull origin master)

#---------- update deno

if command -v deno >/dev/null; then
    deno upgrade
    deno completions fish > "$HOME"/.config/fish/completions/deno.fish
    deno completions zsh > "$HOME"/.oh-my-zsh-custom/plugins/deno/_deno
fi

if command -v bit >/dev/null; then
    bit update
fi
