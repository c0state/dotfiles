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

if [[ -r "$HOME/.dotfiles/agents/copilot/copilot.zsh" ]]; then
  source "$HOME/.dotfiles/agents/copilot/copilot.zsh"
fi

# some agents set the pager (eg: antigravity), usually to cat, so don't modify if so
if [[ -z "$PAGER" ]]; then
  alias cat=bat
fi

#---------- clipboard (pbcopy/pbpaste on Linux)

if [ "$(uname -s)" = "Linux" ]; then
  if [ -n "$WSL_DISTRO_NAME" ]; then
    alias pbcopy="clip.exe"
    alias pbpaste="powershell.exe -noprofile -command Get-Clipboard"
  elif command -v wl-copy >/dev/null 2>&1; then
    alias pbcopy="wl-copy"
    alias pbpaste="wl-paste"
  elif command -v xclip >/dev/null 2>&1; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
  fi
fi

#----- node config

# linuxbrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"

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
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

#----- add fastlane to path
if [[ -e "$HOME/.fastlane/bin" ]]; then
  export PATH=$HOME/.fastlane/bin:$PATH
fi

#----- php version manager
if [[ -e "${HOME}/.php-version" ]]; then
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

#----- deno
export PATH=$PATH:$HOME/.deno/bin

#----- kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#----- homebrew gnu utils
export PATH="$MACOS_BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

#----- keychain agent
if command -v keychain >/dev/null; then
  eval "$(keychain --eval --quiet)"
fi

#----- source any custom shell configuration
[[ -f $HOME/.shellrc_custom.sh ]] && source $HOME/.shellrc_custom.sh
