# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="c0state"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#----- set path to system agnostic apps
export PATH=$PATH:~/Dropbox/Apps/Universal/bin:~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4/bin

#----- set based on platform (Linux or OS X)
if [[ $OSTYPE =~ ^.*linux.* ]]; then
  export PATH=/mnt/data/opt/jdk1.6.0_30/bin:$PATH:~/Dropbox/Apps/Linux/bin:~/Dropbox/Apps/Linux/android-sdk-linux_x86/tools:~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools:~/Dropbox/Apps/Linux/nodejs/x86_64-pc-linux-gnu/bin

  export JAVA_HOME=/mnt/data/opt/jdk1.6.0_30/bin
elif [[ $OSTYPE =~ ^.*darwin.* ]]; then
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export PATH=$PATH:~/Dropbox/Apps/OSX/bin:~/Dropbox/Apps/OSX/android-sdk-mac_x86/platform-tools:~/Dropbox/Apps/OSX/android-sdk-mac_x86/tools:~/Dropbox/Apps/OSX/q/m32:~/Dropbox/Apps/OSX/android-fastboot

  export JAVA_HOME=`/usr/libexec/java_home`

  source /opt/local/bin/virtualenvwrapper.sh-2.6
elif [[ $OSTYPE =~ ^.*cygwin.* ]]; then
  export PATH=$PATH:~/Dropbox/Apps/Windows/android-sdk-windows/platform-tools:~/Dropbox/Apps/Windows/android-sdk-windows/tools
fi

#----- for Amazon AWS EC2 tools
export EC2_HOME=~/Dropbox/Apps/Universal/ec2-api-tools-1.4.2.4
export EC2_PRIVATE_KEY=~/Dropbox/AmazonAWS/X509Key
export EC2_CERT=~/Dropbox/AmazonAWS/X509Cert

ZBEEP='\e[?5h\e[?5l'

EDITOR=vim

DISABLE_AUTO_TITLE=true

# use vi bindings
#bindkey -v

source ~/.bash_functions
source ~/.bash_aliases

# virtualenvwrapper
. /etc/bash_completion.d/virtualenvwrapper
