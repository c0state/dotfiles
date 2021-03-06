#!/usr/bin/env fish

if ! type -q fisher
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

fisher install evanlucas/fish-kubectl-completions
fisher install PatrickF1/fzf.fish

