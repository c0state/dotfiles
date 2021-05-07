#!/usr/bin/env bash

set -eu

# -*- coding: utf-8 -*-

# <xbar.title>Kubernetes Zombie Pods Check</xbar.title>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>This plugin displays the build status of repositories listed on CircleCI.</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>

# use a regex like the following in $HOME/.xbar_variables to indicate what are stale pods
# [kubernetes]
# STALE_POD_REGEX = ^(cex-)
# STALE_POD_CONTEXT = prod-context
# STALE_POD_NAMESPACE = prod-ns
STALE_POD_REGEX=$(grep STALE_POD_REGEX ~/.xbar_variables | cut -d= -f2 | awk '{ print $1; }')
STALE_POD_CONTEXT=$(grep STALE_POD_CONTEXT ~/.xbar_variables | cut -d= -f2 | awk '{ print $1; }')
STALE_POD_NAMESPACE=$(grep STALE_POD_NAMESPACE ~/.xbar_variables | cut -d= -f2 | awk '{ print $1; }')

export PATH=$PATH:/usr/local/bin
# also add new arm macos compatible homebrew path
export PATH=$PATH:/opt/homebrew/bin

# anything older than a day is considered stale
STALE_PODS=$(\
  kubectl get pods --context "$STALE_POD_CONTEXT" --namespace "$STALE_POD_NAMESPACE" | \
  grep -E -v "^$STALE_POD_REGEX" | grep '[0-9]d[0-9a-z]*$' || echo "" \
)

if test -n "$STALE_PODS" ; then
  echo "Stale Pods|color=red"
  echo ---
  echo "$STALE_PODS"
else
  echo "No Stale Pods"
fi
