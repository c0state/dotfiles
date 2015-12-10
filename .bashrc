#----- detect platform
PLATFORM=`uname`

#----- increase history file sizes
export HISTSIZE=10000
export HISTFILESIZE=20000

export EDITOR=vim

#----- set terminal title
if [[ $TERM == xterm* ]] || [[ $TERM == rxvt* ]]
then
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
fi

#----- set shell prompt
export PS1='\[\e[0;31m\][\D{%Y-%m-%d} \t]\[\e[m\]\[\e[0;37m\]\u@\h\[\e[m\]\[\e[0;32m\][$HOSTTYPE][\w]\[\e[m\]\n> '

#----- set based on platform (Linux or OS X)
if [[ $PLATFORM == 'Linux' ]]; then
  export PATH=$PATH:~/Dropbox/Apps/Linux/bin:~/Dropbox/Apps/Linux/android-sdk-linux_x86/tools:~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools:/usr/local/heroku/bin

  . /usr/local/bin/virtualenvwrapper.sh
elif [[ $PLATFORM == 'Darwin' ]]; then
  # if macports is installed put it's bin dir first
  if [[ -e /opt/local/bin/port ]]; then
    export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin:$PATH
    source /usr/local/share/python/virtualenvwrapper.sh
  fi

  # if homebrew is installed put it's bin dir first
  if [[ -e /usr/local/bin/brew ]]; then
    export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/python:$PATH
  fi

  # if heroku toolbelt is installed
  if [[ -e /usr/local/heroku/bin ]]; then
    export PATH=/usr/local/heroku/bin:$PATH
  fi

  if [ -n "$BASH_VERSION" ]; then
    if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
      source $(brew --prefix)/share/bash-completion/bash_completion
    fi
  fi

elif [[ $OSTYPE == 'cygwin' ]]; then
  export PATH=/usr/local/bin:/usr/bin:$PATH

  source /bin/virtualenvwrapper.sh
fi 

#----- php version manager
if [[ -e "${HOME}/.php-version" ]] ; then
  export PHP_VERSIONS="${HOME}/.php-version/versions"
  source ~/.php-version/php-version.sh && php-version 5
fi

#----- pyenv
if [[ -e "$HOME/.pyenv" ]] ; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
  #pyenv virtualenvwrapper
fi

#----- load aspnet k version manager (kvm)
[ -s "${HOME}/.kre/kvm/kvm.sh" ] && . "${HOME}/.kre/kvm/kvm.sh" # Load kvm

#----- add system agnostic apps to path
export PATH=$PATH:~/Dropbox/Apps/Universal/bin:~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4/bin

source ~/.bash_functions

#----- for Amazon AWS EC2 tools
export EC2_HOME=~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4
export EC2_PRIVATE_KEY=~/Dropbox/AmazonAWS/X509Key
export EC2_CERT=~/Dropbox/AmazonAWS/X509Cert

# use vi bindings
#set -o vi

source ~/.bash_aliases

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# source any custom bashrc configuration
if [[ -e ~/.bashrc_custom ]] ; then
  source ~/.bashrc_custom
fi
