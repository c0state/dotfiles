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

# TODO: font and colors don't work - need to convert to python script and apply per line I believe

for context in dev staging prod prod-executor; do
  BAD_PODS=$(kubectl get pods --context "$context" --namespace "$context" 2>&1 | grep -E -v 'Running|Completed')

  if [ $(echo "$BAD_PODS" | wc -l) != "1" ]; then
    TOTAL_BAD_PODS="$TOTAL_BAD_PODS
$context | font='Menlo' | color=red"
    TOTAL_BAD_PODS="$TOTAL_BAD_PODS
$BAD_PODS
---"
  fi
done

if test -n "$TOTAL_BAD_PODS" ; then
  echo "Abnormal Pods | color=red | font='Menlo'"
  echo ---"$TOTAL_BAD_PODS"
else
  echo "No Abnormal Pods"
fi
