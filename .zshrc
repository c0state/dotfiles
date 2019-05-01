#---------- oh-my-zsh

# pulled from latest template at
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="c0state"

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
    git
    git-extras
    pip
    python
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...
#
source $HOME/.shellrc

source $HOME/.zsh_functions

# flash instead of audible beep
ZBEEP='\e[?5h\e[?5l'

# for zsh online help
unalias run-help 2>/dev/null
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# aws auto-completion needs to be explicitly sourced
if [[ -e /usr/local/share/zsh/site-functions/_aws ]]; then
    source /usr/local/share/zsh/site-functions/_aws
elif [[ -e /usr/local/bin/aws_zsh_completer.sh ]]; then
    source /usr/local/bin/aws_zsh_completer.sh
fi

# for google-cloud-sdk
if [[ $PLATFORM == 'Darwin' ]]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# direnv - https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
