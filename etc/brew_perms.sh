#!/bin/bash

# Adapted from: https://gist.github.com/jaibeee/9a4ea6aa9d428bc77925

# Configure homebrew permissions to allow multiple users on MAC OSX.
# Any user from the admin group will be able to manage the homebrew and cask installation on the machine.

# allow admins to manage homebrew's local install directory
if [[ -d /usr/local ]]; then
  chgrp -R admin /usr/local
  chmod -R g+w /usr/local
fi

# allow admins to homebrew's local cache of formulae and source files
if [[ -d /Library/Caches/Homebrew ]]; then
  chgrp -R admin /Library/Caches/Homebrew
  chmod -R g+w /Library/Caches/Homebrew
fi
