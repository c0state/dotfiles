#!/usr/bin/env bash

#----- detect platform
PLATFORM=$(uname)
PLATFORM_FULL=$(uname -a)
MACH_TYPE=$(uname -m)
if [[ "$PLATFORM" == "Darwin" && "$MACH_TYPE" == "arm64" ]]; then
    IS_MACOS_ARM=1
fi
if [[ "$PLATFORM" == "Darwin" ]]; then
    if [[ -n "$IS_MACOS_ARM" ]]; then
        MACOS_BREW_PREFIX="/opt/homebrew"
    else
        MACOS_BREW_PREFIX="/usr/local/Homebrew"
    fi
fi

#----- increase history file sizes
export HISTSIZE=5000
export HISTFILESIZE=10000

#----- set preferred editor and mode(s)
export EDITOR=vim

#----- misc settings
export REPORTTIME=3

# explicitly set TERM to fix issues with tmux
export TERM=xterm-256color

source "$HOME"/.shell_aliases

if [[ "$PLATFORM" == "Linux" ]]; then
    alias bat=batcat
    alias cat=batcat
else
    alias cat=bat
fi

#----- node config

# linuxbrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";

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
#export PATH="$HOME/.rbenv/bin:$PATH"
#if command -v rbenv >/dev/null; then
#  eval "$(rbenv init -)"
#fi
#
#if command -v ruby >/dev/null && command -v gem >/dev/null; then
#  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
#fi

#----- golang
export GOPATH="$HOME/work/go"
export PATH="$HOME/.local/go/bin":"$GOPATH/bin":$PATH

#----- rust
if [[ -e "$HOME/.cargo" ]]; then
    source "$HOME/.cargo/env"
fi

#----- postgres

if [[ "$PLATFORM" == "Darwin" ]]; then
    for pg_dir in /opt/homebrew/opt/postgresql*/bin; do
        export PATH=:$pg_dir:$PATH
    done
fi

#----- git-subrepo
if [[ -e $HOME/.git-subrepo/.rc ]]; then
    source $HOME/.git-subrepo/.rc
fi

#----- python
if command -v register-python-argcomplete > /dev/null; then
    eval "$(register-python-argcomplete pipx)"
fi

#----- deno
export PATH=$PATH:$HOME/.deno/bin

#----- volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#----- kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#----- homebrew gnu utils
export PATH="$MACOS_BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

#----- keychain agent
if command -v keychain > /dev/null; then
    eval "$(keychain --eval --quiet)"
fi

#----- google drive
if command -v google-drive-ocamlfuse > /dev/null && test -z "$WSL_DISTRO_NAME"; then
    GDRIVE_FOLDER="Google.Drive"
    mount | grep "${HOME}/${GDRIVE_FOLDER}" >/dev/null || google-drive-ocamlfuse "${HOME}/${GDRIVE_FOLDER}" &
fi

#----- source any custom shell configuration
[[ -f $HOME/.shellrc_custom.sh ]] && source $HOME/.shellrc_custom.sh
