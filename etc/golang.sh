#!/usr/bin/env bash

set -ex

#---------- variables

GO_VERSION=1.16
PLATFORM=$(uname)
CPUTYPE=$(uname -m)

if [[ "$PLATFORM" == "Darwin" ]]; then
    PLATFORM_STRING="darwin"
elif [[ "$PLATFORM" == "Linux" ]]; then
    PLATFORM_STRING="linux"
else
    echo Platform "$PLATFORM" not supported
    exit 1
fi

#---------- install section

if ! command -v go >/dev/null; then
    mkdir -p ~/.local
    wget -qO- https://golang.org/dl/go"$GO_VERSION"."$PLATFORM_STRING"-"$CPUTYPE".tar.gz | tar zxvf - -C "$HOME"/.local
fi

# go repl
go get -u github.com/motemen/gore/cmd/gore

# kail
bash <( curl -sfL https://raw.githubusercontent.com/boz/kail/master/godownloader.sh) -b "$GOPATH/bin"

