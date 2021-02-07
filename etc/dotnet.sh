#!/usr/bin/env bash

PLATFORM=$(uname)

if [[ $PLATFORM != 'Linux' ]]; then
    echo "Dotnet install script is only for Debian Linux"
    exit 0
fi

if command -v dotnet >/dev/null; then
    exit 0
fi

bash -i -c "install_package https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb"

sudo apt-get update
sudo apt-get -y install dotnet-sdk-5.0
