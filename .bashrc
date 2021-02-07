source "$HOME"/.shellrc

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

#---------- nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#---------- fzf

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#---------- bit https://github.com/chriswalz/bit

complete -C /usr/local/bin/bit bit

