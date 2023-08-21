#!/usr/bin/env bash

set -eu

PLATFORM=$(uname)

if [[ $PLATFORM == 'Linux' ]]; then
    sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get install -y apt-transport-https ca-certificates gnupg
    sudo apt-get update && sudo apt-get install -y kubectl
fi

# install kubectl krew packages

kubectl krew upgrade
kubectl krew index add kvaps https://github.com/kvaps/krew-index || true
kubectl krew install kvaps/node-shell

# https://github.com/boz/kail

kubectl krew install tail

if which helm; then
    helm repo add autoscaler https://kubernetes.github.io/autoscaler
    helm repo add datadog https://helm.datadoghq.com
fi
