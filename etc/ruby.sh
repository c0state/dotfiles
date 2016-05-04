#!/usr/bin/env bash

if [ -n "$(type rvm)" ]; then
    rvm get stable
else    
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
fi

