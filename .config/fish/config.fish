#---------- prompt

starship init fish | source

#---------- fzf.fish

bind --erase \cf
bind \co __fzf_search_current_dir

#---------- pyenv

set -Ux PYENV_ROOT $HOME/.pyenv
contains $PYENV_ROOT/bin $fish_user_paths; or set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

