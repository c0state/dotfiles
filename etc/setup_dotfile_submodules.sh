#!/usr/bin/env bash

(
    cd "$HOME"/.dotfiles &&
    git submodule update --init --recursive --remote
) || false
