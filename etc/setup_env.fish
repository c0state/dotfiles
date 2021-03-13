#!/usr/bin/env fish

#---------- fisher

# TODO: do we still need fisher?

#if ! type -q fisher
#    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
#end
#
#fisher install evanlucas/fish-kubectl-completions

#---------- oh-my-fish

if not type -q omf
    curl -L https://get.oh-my.fish | fish
end

omf install fzf
omf install nvm
omf install pyenv
