#!/usr/bin/env fish

#---------- oh-my-fish

if not type -q omf
    curl -L https://get.oh-my.fish | fish
end

omf install fzf
omf install nvm
omf install pyenv
