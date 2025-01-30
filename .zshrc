# uncomment to profile startup
# zmodload zsh/zprof

export SHELL=/bin/zsh

#---------- load custom zsh init

[[ -f $HOME/.zshrc_pre_custom ]] && source $HOME/.zshrc_pre_custom

#---------- oh-my-zsh

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

zstyle ':omz:update' mode disabled  # disable automatic updates

ENABLE_CORRECTION="false"
HIST_STAMPS="yyyy-mm-dd"

ZSH_CUSTOM=~/.oh-my-zsh-custom

plugins=(
    brew
    colorize
    deno
    docker
    docker-compose
    fast-syntax-highlighting
    fzf-tab
    gcloud
    git
    git-extras
    golang
    # iterm2
    kubectl
    # pip
    poetry
    python
    # web-search
    # yarn
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    # zsh_codex
)

source $ZSH/oh-my-zsh.sh

# User configuration

# ---------- zsh-autosuggestions

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# ---------- always show completions https://unix.stackexchange.com/a/30092/230764

zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''

# ---------- fzf-tab

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' show-group full

# ---------- zsh-autocomple - https://github.com/marlonrichert/zsh-autocomplete

zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-complete

#---------- load up shell agnostic interactive config

if [[ -e $HOME/.shell_interactive.sh ]]; then
    source $HOME/.shell_interactive.sh
fi

# ---------- zsh functions

source $HOME/.zsh_functions

# ---------- history

setopt HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

# ---------- direnv - https://github.com/direnv/direnv

eval "$(direnv hook zsh)"

# ---------- fzf

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# ---------- google cloud sdk

if [ -f "$HOME"/.local/google-cloud-sdk/path.zsh.inc ]; then
    source "$HOME"/.local/google-cloud-sdk/path.zsh.inc
    source "$HOME"/.local/google-cloud-sdk/completion.zsh.inc
fi

# ---------- bit - https://github.com/chriswalz/bit

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/.local/bin/bit bit

# ---------- zsh codex - https://github.com/tom-doerr/zsh_codex

bindkey '^X' create_completion

#---------- command prompt

eval "$(starship init zsh)"

# uncomment to profile startup
# zprof
