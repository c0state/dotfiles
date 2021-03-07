#---------- prompt

starship init fish | source

#---------- fzf.fish

bind --erase \cf
bind \co __fzf_search_current_dir

set PYENV_ROOT ~/.pyenv;
set PATH $PATH $PYENV_ROOT/bin;
set PATH $PATH ~/.local/bin;

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

