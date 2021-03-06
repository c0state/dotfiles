#---------- prompt

starship init fish | source

#---------- pyenv

set -Ux PYENV_ROOT $HOME/.pyenv
set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

