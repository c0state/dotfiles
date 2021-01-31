source "$HOME"/.shellrc

source "$HOME"/.bash_functions

# direnv - https://github.com/direnv/direnv
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

