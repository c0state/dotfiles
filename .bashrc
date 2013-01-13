#----- detect platform
PLATFORM=`uname`

#----- increase history file sizes
HISTSIZE=10000
HISTFILESIZE=20000

#----- set terminal title
if [[ $TERM = "xterm" ]] || [[ $TERM = "rxvt" ]]
then
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}[${HOSTTYPE}]:${PWD}\007"'
  PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
fi

#----- set shell prompt
export PS1='\[\e[0;31m\][\t]\[\e[m\]\[\e[0;37m\]\u@\h\[\e[m\]\[\e[0;32m\][$HOSTTYPE][\w]\[\e[m\]\n> '

#----- set path to system agnostic apps
export PATH=$PATH:~/Dropbox/Apps/Universal/bin:~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4/bin

#----- set based on platform (Linux or OS X)
if [[ $PLATFORM == 'Linux' ]]; then
  export PATH=$PATH:~/Dropbox/Apps/Linux/bin:~/Dropbox/Apps/Linux/android-sdk-linux_x86/tools:~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools:/usr/local/heroku/bin
elif [[ $PLATFORM == 'Darwin' ]]; then
  export PATH=$PATH:/opt/local/bin:/opt/local/sbin
  export PATH=$PATH:~/Dropbox/Apps/OSX/bin:~/Dropbox/Apps/OSX/android-sdk-mac_x86/platform-tools:~/Dropbox/Apps/OSX/android-sdk-mac_x86/tools:~/Dropbox/Apps/OSX/q/m32:~/Dropbox/Apps/OSX/android-fastboot
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

# virtualenvwrapper
. /etc/bash_completion.d/virtualenvwrapper
