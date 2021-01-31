#!/usr/bin/env bash

set -ex

LATEST_RUBY_VERSION=3.0.0

if [[ ! -e $HOME/.rbenv ]]; then
    git clone https://github.com/rbenv/rbenv $HOME/.rbenv
    (cd $HOME/.rbenv && src/configure && make -C src)
fi

if [[ ! -e $HOME/.rbenv/plugins/rbenv-gemset ]]; then
    git clone https://github.com/jf/rbenv-gemset.git $HOME/.rbenv/plugins/rbenv-gemset
fi

if [[ ! -e $HOME/.rbenv/plugins/ruby-build ]]; then
    git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi

eval "$(rbenv init -)"

if ! (rbenv version | grep $LATEST_RUBY_VERSION); then
    rbenv install 3.0.0
fi

gem install --user-install cocoapods
gem install --user-install fastlane
gem install --user-install s3_website
gem install --user-install terraforming
gem install --user-install tmuxinator
