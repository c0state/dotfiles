#!/usr/bin/env bash

set -eux

# add kubernetes repos
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /etc/apt/trusted.gpg.d/google-cloud.gpg

# install dependencies
sudo apt-get install apt-transport-https ca-certificates gnupg

# install kubectl
sudo apt-get update && sudo apt-get install kubectl

