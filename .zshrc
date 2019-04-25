source $HOME/.shellrc

source $HOME/.zsh_functions

#---------- zplug

source ~/.zplug/init.zsh

# oh-my-zsh plugins
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/git-extras",   from:oh-my-zsh
zplug "plugins/pip",   from:oh-my-zsh
zplug "plugins/python",   from:oh-my-zsh

# zsh-users plugins
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

# load custom bundles
zplug "~/.oh-my-zsh-custom", from:local

# Load custom theme
zplug "~/.oh-my-zsh-custom", from:local, as:theme, use:c0state.zsh-theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

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
if [[ $PLATFORM == 'Darwin' ]]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# direnv - https://github.com/direnv/direnv
eval "$(direnv hook zsh)"
