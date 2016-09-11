source $HOME/.shellrc

source $HOME/.zsh_functions

#---------- antigen 

if [[ $PLATFORM == 'Darwin' ]]; then
    source $(brew --prefix)/share/antigen/antigen.zsh
elif [[ -e /usr/share/zsh-antigen/antigen.zsh ]]; then
    source /usr/share/zsh-antigen/antigen.zsh
else
    echo "Could not find antigen!" 1>&2
    exit 1
fi

# Load the oh-my-zsh library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle robbyrussell/oh-my-zsh plugins/git
antigen bundle robbyrussell/oh-my-zsh plugins/git-extras
antigen bundle robbyrussell/oh-my-zsh plugins/pip
antigen bundle robbyrussell/oh-my-zsh plugins/python

# zsh-users bundles
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

# load custom bundles
antigen bundle $HOME/.dotfiles/.oh-my-zsh-custom

# Load custom theme
antigen theme "$HOME/.dotfiles/.oh-my-zsh-custom" c0state

antigen apply

# ---------- Customize to your needs...

# don't auto rename windows in tmux, etc.
DISABLE_AUTO_TITLE=true

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
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
