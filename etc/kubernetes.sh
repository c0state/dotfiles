#!/usr/bin/env bash

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /etc/apt/trusted.gpg.d/google-cloud.gpg
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

