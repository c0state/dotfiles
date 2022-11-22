#!/usr/bin/env bash

set -eu

PLATFORM=$(uname)

if [[ $PLATFORM == 'Linux' ]]; then
    # add kubernetes repos
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo curl -LS https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
    
    # install dependencies
    sudo apt-get install apt-transport-https ca-certificates gnupg
    
    # install kubectl
    sudo apt-get update && sudo apt-get install kubectl
fi

# install kubectl krew packages

kubectl krew index add kvaps https://github.com/kvaps/krew-index || true
kubectl krew install kvaps/node-shell

if which helm; then
    helm repo add autoscaler https://kubernetes.github.io/autoscaler
    helm repo add datadog https://helm.datadoghq.com
fi


