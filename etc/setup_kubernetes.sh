#!/usr/bin/env bash

set -eux

# add kubernetes repos
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo bash -c "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg > /usr/share/keyrings/kubernetes-archive-keyring.gpg"

# install dependencies
sudo apt-get install apt-transport-https ca-certificates gnupg

# install kubectl
sudo apt-get update && sudo apt-get install kubectl

