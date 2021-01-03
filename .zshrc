#---------- load custom zsh init

[[ -f $HOME/.zshrc_pre_custom ]] && source $HOME/.zshrc_pre_custom

#---------- load up shell agnostic config

source $HOME/.shellrc

#---------- command prompt

# intellij and vscode themes don't seem to play nice with custom prompt colors
if [[ $__INTELLIJ_COMMAND_HISTFILE__ || "$TERM_PROGRAM" = "vscode" ]]; then
  ZSH_THEME="agnoster"
else
  eval "$(starship init zsh)"
fi

#---------- oh-my-zsh

export ZSH=$HOME/.oh-my-zsh

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=1
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=~/.oh-my-zsh-custom

# ---------- nvm

export NVM_LAZY=1

# ---------- plugins list

plugins=(
    brew
    colorize
    docker
    docker-compose
    git
    git-extras
    golang
    iterm2
    kubectl
    nvm
    pip
    poetry
    python
    yarn
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...

source $HOME/.zsh_functions

setopt HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

# flash instead of audible beep
unsetopt BEEP
ZBEEP='\e[?5h\e[?5l'

# for zsh online help
unalias run-help 2>/dev/null
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# ---------- aws auto-completion needs to be explicitly sourced
# use https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#aws instead?

if [[ -e /usr/local/share/zsh/site-functions/_aws ]]; then
    source /usr/local/share/zsh/site-functions/_aws
elif [[ -e /usr/local/bin/aws_zsh_completer.sh ]]; then
    source /usr/local/bin/aws_zsh_completer.sh
fi

# ---------- direnv - https://github.com/direnv/direnv

eval "$(direnv hook zsh)"

# ---------- fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------- bit - https://github.com/chriswalz/bit

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/bitcomplete bit

