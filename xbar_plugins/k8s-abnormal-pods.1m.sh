#!/usr/bin/env bash

set -eu

# -*- coding: utf-8 -*-

# <xbar.title>Kubernetes Abnormal Pods Check</xbar.title>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>This plugin displays any abnormal pods in kubernetes.</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>

export PATH=$PATH:/usr/local/bin
# also add new arm macos compatible homebrew path
export PATH=$PATH:/opt/homebrew/bin

TOTAL_BAD_PODS=""

for context in dev dev-executor staging staging-executor prod prod-executor; do
  for namespace in "$context-executor" global kube-system; do
    BAD_PODS=$(kubectl get pods --context "$context" --namespace $namespace 2>&1 | \
      grep -E -v 'Running|Completed|ContainerCreating|Pending')
    BAD_PODS=$(echo "$BAD_PODS" | awk '{ print $0 " | font=Menlo"; }')

    if [ $(echo "$BAD_PODS" | wc -l) != "1" ]; then
      TOTAL_BAD_PODS="$TOTAL_BAD_PODS
$context | color=red | font=Menlo
---"
      TOTAL_BAD_PODS="$TOTAL_BAD_PODS
$BAD_PODS
---"
    fi
  done
done

if test -n "$TOTAL_BAD_PODS" ; then
  echo "Abnormal Pods | color=red"
  echo ---"$TOTAL_BAD_PODS"
else
  echo "No Abnormal Pods"
fi
