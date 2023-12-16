#!/usr/bin/env bash

PLATFORM=$(uname)

if [[ $PLATFORM != 'Linux' ]]; then
    echo "This script is only for Debian based Linux systems"
    exit 0
fi

sudo apt-get update
sudo apt-get -y install dotnet-sdk-8.0
