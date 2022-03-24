#!/usr/bin/env bash

#----- detect platform
PLATFORM=$(uname)
IS_MACOS_ARM=$(uname -a | grep -i "darwin.*arm64" || echo "")

#----- increase history file sizes
export HISTSIZE=5000
export HISTFILESIZE=10000

#----- set preferred editor and mode(s)
export EDITOR=vim

#----- misc settings
export REPORTTIME=3

source "$HOME"/.shell_aliases

#----- set based on platform (Linux or OS X)
if [[ $PLATFORM == 'Darwin' ]]; then
  if [[ ! -z $IS_MACOS_ARM ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
  else
    eval $(/usr/local/Homebrew/bin/brew shellenv)
  fi
fi 

#----- node config

# add yarn global bin path
if [[ -e "$HOME/.yarn/bin" ]]; then
  export PATH=$HOME/.yarn/bin:$PATH
fi

#----- add android sdk paths
if [[ -e "$HOME/Android/sdk" ]]; then
  export ANDROID_SDK_ROOT=$HOME/Android/sdk
elif [[ -e $HOME/Library/Android/sdk ]]; then
  export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
fi

if [[ -n "$ANDROID_SDK_ROOT" ]]; then
  export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
  export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
  export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
fi

#----- add system agnostic apps to path
export PATH=$PATH:$HOME/bin:$HOME/.local/bin

#----- add fastlane to path
if [[ -e "$HOME/.fastlane/bin" ]]; then
  export PATH=$HOME/.fastlane/bin:$PATH
fi

#----- php version manager
if [[ -e "${HOME}/.php-version" ]] ; then
  export PHP_VERSIONS="${HOME}/.php-version/versions"
  source $HOME/.php-version/php-version.sh && php-version 5
fi

#----- ruby
export PATH="$HOME/.rbenv/bin:$PATH"
if command -v rbenv >/dev/null; then
  eval "$(rbenv init -)"
fi

if command -v ruby >/dev/null && command -v gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

#----- golang
export GOPATH="$HOME/work/go"
export PATH="$HOME/.local/go/bin":"$GOPATH/bin":$PATH

#----- rust
if [[ -e "$HOME/.cargo" ]]; then
    source "$HOME/.cargo/env"
fi

#----- git-subrepo
if [[ -e $HOME/.git-subrepo/.rc ]]; then
    source $HOME/.git-subrepo/.rc
fi

#----- python
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export PATH=$PATH:$(python3 -m site --user-base)/bin
export PATH="$PATH:$HOME/.poetry/bin"
if [[ ! -z $IS_MACOS_ARM ]]; then
    export PATH="$PATH:$HOME/Library/Python/3.9/bin"
fi

eval "$(register-python-argcomplete pipx)"

#----- deno
export PATH=$PATH:$HOME/.deno/bin

#----- docker
export DOCKER_BUILDKIT=1

#----- volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#----- kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#----- keychain agent
eval $(keychain --eval --quiet)

#----- source any custom shell configuration
[[ -f $HOME/.shellrc_custom.sh ]] && source $HOME/.shellrc_custom.sh

