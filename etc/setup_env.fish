#!/usr/bin/env fish

#---------- oh-my-fish

if not type -q omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
else
    omf update
end

set omf_packages \
    fzf \
    pyenv

for omf_package in $omf_packages
    omf list | grep "$omf_package" || omf install "$omf_package"
end

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

