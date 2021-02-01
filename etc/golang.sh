#!/usr/bin/env bash

set -ex

GO_VERSION=1.15.7

if ! command -v go >/dev/null; then
    mkdir -p ~/.local
    wget -qO- https://golang.org/dl/go"$GO_VERSION".linux-amd64.tar.gz | tar zxvf - -C $HOME/.local
fi

go get -u github.com/motemen/gore/cmd/gore
