#!/usr/bin/env bash

# build these targets if you need to debug
# docker build --tag dotfiles-base --target dotfiles-base .
# docker build --tag dotfiles-tools --target dotfiles-tools .

docker build --tag dotfiles .
