#!/usr/bin/env fish

#---------- oh-my-fish

if not type -q omf
    set TEMP_FILE (mktemp)
    curl -L https://get.oh-my.fish > $TEMP_FILE
    chmod +x $TEMP_FILE
    $TEMP_FILE --noninteractive --yes
    rm -f "$TEMP_FILE"
    set --erase TEMP_FILE
else
    omf update
end

omf install fzf
omf install pyenv

#---------- poetry

poetry completions fish > $HOME/.config/fish/completions/poetry.fish

#---------- pipx

register-python-argcomplete --shell fish pipx > "$HOME"/.config/fish/completions/pipx.fish

#---------- docker completions

curl https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish --output "$HOME"/.config/fish/completions/docker.fish

#---------- kubectl completions

mkdir -p "$HOME"/.config/fish/completions
curl --location --output "$HOME"/.config/fish/completions/kubectl.fish \
    https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/master/completions/kubectl.fish

