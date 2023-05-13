#---------- constants

# platform
set --local PLATFORM_FULL (uname -a)
set --local PLATFORM (echo $PLATFORM_FULL | cut -d ' ' -f 1)
set --local IS_MACOS_ARM (echo $PLATFORM_FULL | grep -i "darwin.*arm64" || echo "")
set --local IS_WSL (echo $PLATFORM_FULL | grep -i microsoft || echo "")

# misc
set --local REPORTTIME 3

#---------- vars

set -gx EDITOR vim

if test "$PLATFORM" = "Darwin"
    set -gx SHELL /opt/homebrew/bin/fish
else
    set -gx SHELL /bin/fish
end

#---------- aliases and functions

source ~/.shell_aliases.fish
source ~/.shell_functions.fish

#---------- homebrew

if test "$PLATFORM" = "Darwin"
    if test -n $IS_MACOS_ARM
        eval (/opt/homebrew/bin/brew shellenv)
    else
        eval (/usr/local/Homebrew/bin/brew shellenv)
    end
end

# explicitly set TERM to fix issues with tmux
set -gx TERM xterm-256color

#---------- paths

set -gx PATH $PATH ~/.local/bin;

# linuxbrew
set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
set -gx PATH "/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin" $PATH
set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH
set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info}" $INFOPATH

#----- js tools

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# deno
set -gx PATH "$HOME/.deno/bin" $PATH

# docker
set -gx DOCKER_BUILDKIT 1

#----- python

# poetry
set -gx PATH "$HOME/.poetry/bin" $PATH

# system binary path
set -gx PATH (python3 -m site --user-base)"/bin" $PATH

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin

    pyenv init - | source
end

#----- ruby

#set -gx PATH "$HOME/.rbenv/bin" $PATH
#if command -v rbenv >/dev/null
#  eval "$(rbenv init -)"
#end

#----- rust
set -gx PATH "$HOME/.cargo/bin" $PATH

#----- golang
set -gx GOPATH "$HOME/work/go"
set -gx PATH "$HOME/.local/go/bin" "$GOPATH/bin" $PATH

#----- kubectl krew
set -gx PATH $PATH $HOME/.krew/bin

#---------- kubectl

#----- completions

if type -q aws_completer
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

#---------- keychain agent

if type -q keychain
    keychain --eval --quiet --quick | source
end

#---------- google drive

if type -q google-drive-ocamlfuse && ping -q -c 1 -W 1 8.8.8.8 >/dev/null
    set --local GDRIVE_FOLDER "Google.Drive"
    mount | grep "$HOME/$GDRIVE_FOLDER" >/dev/null || \
        begin; test -e "$HOME/$GDRIVE_FOLDER" && google-drive-ocamlfuse "$HOME/$GDRIVE_FOLDER"; end
end

#---------- gcloud

if test -e "$HOME/.local/google-cloud-sdk/path.fish.inc"
    source "$HOME/.local/google-cloud-sdk/path.fish.inc"
end

#---------- load custom settings

if test -e $HOME/.shellrc_custom.fish
    source $HOME/.shellrc_custom.fish
end

#---------- prompt

starship init fish | source

#---------- direnv

# https://github.com/direnv/direnv/blob/master/docs/hook.md
direnv hook fish | source
