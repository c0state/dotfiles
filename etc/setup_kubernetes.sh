#!/usr/bin/env bash

set -eu

PLATFORM=$(uname)
K8S_VERSION="v1.36"

if [[ $PLATFORM == 'Linux' ]]; then
  sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/"$K8S_VERSION"/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.sources >/dev/null
Types: deb
URIs: https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/
Suites: /
Signed-By: /etc/apt/keyrings/kubernetes-apt-keyring.gpg
EOF

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
