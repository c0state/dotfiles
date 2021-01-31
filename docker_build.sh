#!/usr/bin/env bash

docker build --tag dotfiles-base --target dotfiles-base .
docker build --tag dotfiles-tools --target dotfiles-tools .
docker build --tag dotfiles .
