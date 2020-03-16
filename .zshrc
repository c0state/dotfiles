[[ -f $HOME/.zshrc_pre_custom ]] && source $HOME/.zshrc_pre_custom

#---------- load up shell agnostic config first

source $HOME/.shellrc

#---------- oh-my-zsh

# pulled from latest template at
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

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
    python
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...

source $HOME/.zsh_functions

# flash instead of audible beep
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

# ---------- google-cloud-sdk

if [[ $PLATFORM == 'Darwin' ]]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# ---------- direnv - https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# ---------- fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------- powerlevel9k powerline

# powerlevel9k theme
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs pyenv rbenv go_version)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator kubecontext time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# powerlevel9k colors
POWERLEVEL9K_DIR_HOME_FOREGROUND=yellow1
POWERLEVEL9K_DIR_HOME_BACKGROUND=blue
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=yellow1
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=blue
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=lightgrey
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=blue
POWERLEVEL9K_DIR_ETC_FOREGROUND=yellow1
POWERLEVEL9K_DIR_ETC_BACKGROUND=blue
POWERLEVEL9K_PYENV_FOREGROUND=lightcyan
POWERLEVEL9K_RBENV_FOREGROUND=lightcyan

# ---------- nvm auto use

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

