#!/usr/bin/env fish

#---------- oh-my-fish

if not type -q omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
else
    omf update
end

set omf_packages \
    https://github.com/tom-doerr/codex.fish \
    fzf

for omf_package in $omf_packages
    omf list | grep "$omf_package" || omf install "$omf_package"
end

#---------- poetry

poetry completions fish > $HOME/.config/fish/completions/poetry.fish

#---------- pipx

if type -q register-python-argcomplete
    register-python-argcomplete --shell fish pipx > "$HOME"/.config/fish/completions/pipx.fish
end

#---------- docker completions

curl https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish --output "$HOME"/.config/fish/completions/docker.fish

#---------- kubectl completions

kubectl completion fish > "$HOME"/.config/fish/completions/kubectl.fish

#---------- nerdctl completions

nerdctl completion fish > "$HOME"/.config/fish/completions/nerdctl.fish

