#!/usr/bin/env fish

#---------- poetry

poetry completions fish > $HOME/.config/fish/completions/poetry.fish

#---------- pipx

if type -q register-python-argcomplete
    register-python-argcomplete --shell fish pipx > "$HOME"/.config/fish/completions/pipx.fish
end

#---------- completions

docker completion fish > "$HOME"/.config/fish/completions/docker.fish
kubectl completion fish > "$HOME"/.config/fish/completions/kubectl.fish
uv generate-shell-completion fish > "$HOME"/.config/fish/completions/uv.fish

if type -q nerdctl ; and nerdctl 2>/dev/null
  nerdctl completion fish > "$HOME"/.config/fish/completions/nerdctl.fish
end

