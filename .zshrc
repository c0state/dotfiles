source ~/.bashrc

#---------- antigen 

source /usr/local/Cellar/antigen/1/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle command-not-found
antigen bundle git
antigen bundle heroku
antigen bundle lein
antigen bundle pip
antigen bundle python
antigen bundle ruby
antigen bundle rupa/z
antigen bundle rvm
antigen bundle zsh-users/zsh-completions src

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme ~/dotfiles.oh-my-zsh-custom/c0state.zsh-theme

# Tell antigen that you're done.
antigen apply

# ---------- Customize to your needs...

# reload aliases as zsh may have mangled some customizations
source ~/.bash_aliases

DISABLE_AUTO_TITLE=true
ZBEEP='\e[?5h\e[?5l'

# for zsh online help
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# rvm
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
