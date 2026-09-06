#!/usr/bin/env bash

set -eu

#---------- variables

GO_VERSION=$(curl -L https://golang.org/VERSION?m=text | head -n 1)
PLATFORM=$(uname)
MACH_TYPE=$(uname -m)

case "$MACH_TYPE" in
  x86_64|amd64)
    ARCH_TYPE="amd64"
    ;;
  aarch64|arm64)
    ARCH_TYPE="arm64"
    ;;
  *)
    echo "Architecture $MACH_TYPE not supported" >&2
    exit 1
    ;;
esac

if [[ "$PLATFORM" == "Darwin" ]]; then
  PLATFORM_STRING="darwin"
elif [[ "$PLATFORM" == "Linux" ]]; then
  PLATFORM_STRING="linux"
else
  echo Platform "$PLATFORM" not supported
  exit 1
fi

#---------- install section

if ! command -v go >/dev/null ||
  ! go version 2>/dev/null | grep -Fq "$GO_VERSION $PLATFORM_STRING/$ARCH_TYPE"; then
  mkdir -p ~/.local
  rm -rf ~/.local/go
  curl -L https://golang.org/dl/"$GO_VERSION"."$PLATFORM_STRING"-"$ARCH_TYPE".tar.gz | tar zxvf - -C "$HOME"/.local
fi

go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
go install github.com/antonmedv/fx@latest
go install github.com/mdempsky/gocode@latest
go install github.com/x-motemen/gore/cmd/gore@latest
