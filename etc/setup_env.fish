#!/usr/bin/env fish

#---------- poetry

poetry completions fish >$HOME/.config/fish/completions/poetry.fish

#---------- completions

docker completion fish >"$HOME"/.config/fish/completions/docker.fish
jj util completion fish >"$HOME"/.config/fish/completions/jj.fish
k9s completion fish >"$HOME"/.config/fish/completions/k9s.fish
kubectl completion fish >"$HOME"/.config/fish/completions/kubectl.fish
uv generate-shell-completion fish >"$HOME"/.config/fish/completions/uv.fish
zellij setup --generate-completion fish >"$HOME"/.config/fish/completions/zellij.fish

if type -q nerdctl; and nerdctl 2>/dev/null
    nerdctl completion fish >"$HOME"/.config/fish/completions/nerdctl.fish
end
