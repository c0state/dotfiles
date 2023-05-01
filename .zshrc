export SHELL=/bin/zsh

#---------- load custom zsh init

[[ -f $HOME/.zshrc_pre_custom ]] && source $HOME/.zshrc_pre_custom

#---------- oh-my-zsh

export ZSH=$HOME/.oh-my-zsh

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
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
    deno
    docker
    docker-compose
    fast-syntax-highlighting
    fzf-tab
    gcloud
    git
    git-extras
    golang
    iterm2
    kubectl
    pip
    poetry
    python
    web-search
    yarn
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    zsh_codex
)

source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...

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
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
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

#---------- command prompt

eval "$(starship init zsh)"

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

[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh

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

