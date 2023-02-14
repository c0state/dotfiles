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
STALE_POD_REGEX=$(grep STALE_POD_REGEX ~/.xbar_variables | cut -d= -f2 | awk '{ print $1; }')

if test -z "$STALE_POD_REGEX"; then
  echo "Not Watching Pods|color=gray"
  echo ---
  echo "Missing configuration"
  exit 0
fi

if test -z "$STALE_POD_REGEX"; then
    echo Missing configuration settings!
    exit 1
fi

export PATH=$PATH:/usr/local/bin
# also add new arm macos compatible homebrew path
export PATH=$PATH:/opt/homebrew/bin

FOUND_ZOMBIE_PODS=0

for namespace in dev staging prod; do
  # anything older than a day is considered stale
  STALE_PODS=$(\
    kubectl get pods --namespace "$namespace" --context "$namespace-executor" | \
    grep -E "$STALE_POD_REGEX" | grep '[0-9]d[0-9a-z]*$' || echo "" \
  )

  if test -n "$STALE_PODS" ; then
    FOUND_ZOMBIE_PODS=1

    echo "Stale Pods|color=red"
    echo ---
    echo $namespace
    echo ---
    echo "$STALE_PODS"
  fi
done

if [[ $FOUND_ZOMBIE_PODS == 0 ]]; then
  echo "No Stale Pods"
  for namespace in dev staging prod; do
    echo ---
    echo $namespace
    kubectl get pods --namespace "$namespace" --context "$namespace-executor" | \
      tail -n +2 | awk '{ print $0 " | font=Menlo" }'
  done
fi
