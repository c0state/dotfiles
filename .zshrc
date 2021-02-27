#---------- load custom zsh init

[[ -f $HOME/.zshrc_pre_custom ]] && source $HOME/.zshrc_pre_custom

#---------- oh-my-zsh

export ZSH=$HOME/.oh-my-zsh

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=1
DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=~/.oh-my-zsh-custom

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
    web-search
    yarn
    # TODO: disable due to "command not found: _autocomplete.extras" error
#    zsh-autocomplete
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...

# ---------- zsh-autocomple - https://github.com/marlonrichert/zsh-autocomplete

zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-complete

#---------- load up shell agnostic interactive config

if [[ -e $HOME/.shell_interactive ]]; then
    source $HOME/.shell_interactive
fi

#---------- command prompt

eval "$(starship init zsh)"

# ---------- nvm

export NVM_LAZY=1

# ---------- zsh functions

source $HOME/.zsh_functions

# ---------- history

setopt HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

# ---------- flash instead of audible beep

unsetopt BEEP
ZBEEP='\e[?5h\e[?5l'

# ---------- online help

unalias run-help 2>/dev/null
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# ---------- direnv - https://github.com/direnv/direnv

eval "$(direnv hook zsh)"

# ---------- fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------- bit - https://github.com/chriswalz/bit

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/bit bit

