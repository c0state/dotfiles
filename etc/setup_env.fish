#!/usr/bin/env fish

#---------- fisher

if ! type -q fisher
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

fisher install evanlucas/fish-kubectl-completions

fisher update

#---------- oh-my-fish

if not type -q omf
    set TEMP_FILE (mktemp)
    curl -L https://get.oh-my.fish > $TEMP_FILE
    chmod +x $TEMP_FILE
    $TEMP_FILE --noninteractive --yes
    rm -f "$TEMP_FILE"
    set --erase TEMP_FILE
end

omf install fzf
omf install nvm
omf install pyenv

#---------- poetry

poetry completions fish > $HOME/.config/fish/completions/poetry.fish

