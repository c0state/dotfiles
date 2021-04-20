#!/usr/bin/env -S bash -i

set -eux

NODE_VERSION=16

# ---------- volta https://github.com/volta-cli/volta

curl https://get.volta.sh | bash -s -- --skip-setup

# ---------- install js tools

volta install yarn
volta install node@"$NODE_VERSION"

# ---------- install yarn global packages

yarn global add \
    aws-cdk \
    cypress \
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

# ---------- install deno https://github.com/denoland/deno

if ! which deno; then
    curl -fsSL https://raw.githubusercontent.com/denoland/deno_install/master/install.sh | sh
fi
