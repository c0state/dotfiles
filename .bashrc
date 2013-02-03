#----- detect platform
PLATFORM=`uname`

#----- increase history file sizes
HISTSIZE=10000
HISTFILESIZE=20000

EDITOR=vim

#----- set terminal title
if [[ $TERM == xterm* ]] || [[ $TERM == rxvt* ]]
then
  #export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}[${HOSTTYPE}]:${PWD}\007"'
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
fi

#----- set shell prompt
export PS1='\[\e[0;31m\][\t]\[\e[m\]\[\e[0;37m\]\u@\h\[\e[m\]\[\e[0;32m\][$HOSTTYPE][\w]\[\e[m\]\n> '

#----- set path to system agnostic apps
export PATH=$PATH:~/Dropbox/Apps/Universal/bin:~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4/bin

#----- set based on platform (Linux or OS X)
if [[ $PLATFORM == 'Linux' ]]; then
  export PATH=$PATH:~/Dropbox/Apps/Linux/bin:~/Dropbox/Apps/Linux/android-sdk-linux_x86/tools:~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools:/usr/local/heroku/bin

  . /etc/bash_completion.d/virtualenvwrapper
elif [[ $PLATFORM == 'Darwin' ]]; then
  # if macports is installed put it's bin dir first
  if [[ -e /opt/local/bin/port ]]; then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  fi

  # if homebrew is installed put it's bin dir first
  if [[ -e /usr/local/bin/brew ]]; then
    export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/python:$PATH
  fi

  export PATH=$PATH:~/Dropbox/Apps/OSX/bin:~/Dropbox/Apps/OSX/android-sdk-mac_x86/platform-tools:~/Dropbox/Apps/OSX/android-sdk-mac_x86/tools:~/Dropbox/Apps/OSX/q/m32:~/Dropbox/Apps/OSX/android-fastboot

  source /usr/local/share/python/virtualenvwrapper.sh
elif [[ $OSTYPE == 'cygwin' ]]; then
  export PATH=$PATH:~/Dropbox/Apps/Windows/android-sdk-windows/platform-tools:~/Dropbox/Apps/Windows/android-sdk-windows/tools
fi 

source ~/.bash_functions

#----- for Amazon AWS EC2 tools
export EC2_HOME=~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4
export EC2_PRIVATE_KEY=~/Dropbox/AmazonAWS/X509Key
export EC2_CERT=~/Dropbox/AmazonAWS/X509Cert

# use vi bindings
#set -o vi

source ~/.bash_aliases

# save a list of ruby gems and python packages installed on this machine
if [[ -d ~/Dropbox ]]; then
  mkdir -p ~/Dropbox/Config/Linux/etc

  if [[ `where gem` != *"not found" ]]; then
    gem list > ~/Dropbox/Config/Linux/etc/gem_list.`hostname`-`uname`.log
  fi
  if [[ `where pip` != *"not found" ]]; then
    pip freeze > ~/Dropbox/Config/Linux/etc/pip_list.`hostname`-`uname`.log
  fi
fi
