#!/usr/bin/env bash

# TODO: consolidate into setup_env.sh

#---------- vars

if [ -n "$GITHUB_TOKEN_SCRIPTS" ]; then
  export GITHUB_TOKEN="$GITHUB_TOKEN_SCRIPTS"
fi

#---------- update dotfiles folder

(cd "$HOME"/.dotfiles && git fetch --all --prune && git pull --rebase --autostash)
(cd "$HOME"/.dotfiles && git submodule update --init --recursive --remote)
(cd "$HOME"/.dotfiles && git submodule foreach git pull origin master)

#---------- update deno

if command -v deno >/dev/null; then
  deno upgrade
fi

if command -v bit >/dev/null; then
  bit update
fi
