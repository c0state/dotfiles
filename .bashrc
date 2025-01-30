export SHELL=/bin/bash

[[ ! -e $HOME/.shell_interactive.sh ]] || source "$HOME"/.shell_interactive.sh

source "$HOME"/.bash_functions

#---------- brew completions

if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

#---------- direnv - https://github.com/direnv/direnv

eval "$(direnv hook bash)"

#---------- set shell prompt

export PS1='\[\e[0;31m\][\D{%Y-%m-%d} \t]\[\e[m\]\[\e[0;37m\]\u@\h\[\e[m\]\[\e[0;32m\][$HOSTTYPE][\w]\[\e[m\]\n> '

#---------- fzf

command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

#---------- google cloud sdk

if [ -f "$HOME"/.local/google-cloud-sdk/path.bash.inc ]; then
    source "$HOME"/.local/google-cloud-sdk/path.bash.inc
    source "$HOME"/.local/google-cloud-sdk/completion.bash.inc
fi

#---------- bit https://github.com/chriswalz/bit

complete -C $HOME/.local/bin/bit bit

