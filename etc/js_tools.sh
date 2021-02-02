#!/usr/bin/env -S bash -i

set -ex

# ---------- install js tools

if [[ ! -e $HOME/.nvm ]]; then
    export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
    ) && source "$NVM_DIR/nvm.sh"
fi

# set default node and install yarn via npm
if ! nvm ls 15 >/dev/null; then
    nvm install 15
    nvm alias default 15
    nvm use default
fi

if ! which yarn>/dev/null; then
    npm install --global yarn
fi

# ---------- install yarn global packages

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

# ---------- install deno

curl -fsSL https://raw.githubusercontent.com/denoland/deno_install/master/install.sh | sh
