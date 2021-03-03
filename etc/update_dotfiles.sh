#!/usr/bin/env bash

(cd "$HOME"/.dotfiles && git pullr --all)
(cd "$HOME"/.dotfiles && git submodule update --init --recursive --remote)

