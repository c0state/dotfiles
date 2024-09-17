#!/usr/bin/env fish

#---------- poetry

poetry completions fish > $HOME/.config/fish/completions/poetry.fish

#---------- pipx

if type -q register-python-argcomplete
    register-python-argcomplete --shell fish pipx > "$HOME"/.config/fish/completions/pipx.fish
end

#---------- docker completions

docker completion fish > "$HOME"/.config/fish/completions/docker.fish

#---------- kubectl completions

kubectl completion fish > "$HOME"/.config/fish/completions/kubectl.fish

#---------- nerdctl completions

nerdctl completion fish > "$HOME"/.config/fish/completions/nerdctl.fish

