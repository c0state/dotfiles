#!/usr/bin/env bash

set -ex

yarn global add \
    aws-cdk \
    detox-cli \
    diff-so-fancy \
    dynamodb-admin \
    expo-cli \
    firebase-tools \
    gatsby-cli \
    imageoptim-cli \
    instant-markdown-d \
    lerna \
    np \
    poi \
    renovate \
    tldr \
    tslab \
    yalc \
    yarn-deduplicate

yarn cache clean
