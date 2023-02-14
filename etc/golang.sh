#!/usr/bin/env bash

set -ex

#---------- variables

GO_VERSION=1.20
PLATFORM=$(uname)
MACH_TYPE=$(uname -m)
ARCH_TYPE=$MACH_TYPE

if [[ "$MACH_TYPE" == "x86_64" ]]; then
    ARCH_TYPE="amd64"
fi

if [[ "$PLATFORM" == "Darwin" ]]; then
    PLATFORM_STRING="darwin"
elif [[ "$PLATFORM" == "Linux" ]]; then
    PLATFORM_STRING="linux"
else
    echo Platform "$PLATFORM" not supported
    exit 1
fi

#---------- install section

if (! command -v go >/dev/null) || ! (go version | grep "$GO_VERSION"); then
    mkdir -p ~/.local
    rm -rf ~/.local/go
    wget -qO- https://golang.org/dl/go"$GO_VERSION"."$PLATFORM_STRING"-"$ARCH_TYPE".tar.gz | tar zxvf - -C "$HOME"/.local
fi

# go repl
go install github.com/x-motemen/gore/cmd/gore@latest
go install github.com/mdempsky/gocode@latest   # for code completion

# kail
bash <( curl -sfL https://raw.githubusercontent.com/boz/kail/master/godownloader.sh) -b "$GOPATH/bin"

