#!/usr/bin/env bash

set -ex

#---------- variables

GO_VERSION=1.16
PLATFORM=$(uname)

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
    wget -qO- https://golang.org/dl/go"$GO_VERSION"."$PLATFORM_STRING"-amd64.tar.gz | tar zxvf - -C "$HOME"/.local
fi

go get -u github.com/motemen/gore/cmd/gore
