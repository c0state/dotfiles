source ~/.bashrc

#---------- antigen 

source /usr/local/Cellar/antigen/1/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
#antigen bundle lein
#antigen bundle command-not-found
antigen bundle ~/.dotfiles/.oh-my-zsh-custom

# Syntax highlighting bundle.
#antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme c0state/dotfiles .oh-my-zsh-custom/c0state

# Tell antigen that you're done.
antigen apply

# ---------- Original oh-my-zsh configuration

# Path to your oh-my-zsh configuration.
#ZSH=$HOME/.oh-my-zsh

# set oh-my-zsh customization path
#ZSH_CUSTOM=~/.dotfiles/.oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="c0state"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)

# antigen handles this now
#source $ZSH/oh-my-zsh.sh

# ---------- Customize to your needs...

# reload aliases as zsh may have mangled some customizations
source ~/.bash_aliases

# http://github.com/rupa/z
source ~/.z.git/z.sh

fpath=(~/.zsh-completions/src $fpath)

DISABLE_AUTO_TITLE=true
ZBEEP='\e[?5h\e[?5l'

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# for zsh-completions (installed via homebrew)
fpath=(/usr/local/share/zsh-completions $fpath)
