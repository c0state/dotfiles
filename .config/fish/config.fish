#---------- constants

set --local PLATFORM (uname)
set --local IS_MACOS_ARM (uname -a | grep -i "darwin.*arm64" || echo "")

#---------- aliases and functions

source ~/.shell_aliases.fish
source ~/.shell_functions.fish

#---------- prompt

starship init fish | source

#---------- paths

set PATH $PATH ~/.local/bin;

#----- js tools

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# deno
set -gx PATH "$HOME/.deno/bin" $PATH

#----- python

# poetry
set -gx PATH "$HOME/.poetry/bin" $PATH

# system binary path
set -gx PATH (python3 -m site --user-base)"/bin" $PATH

#----- rust
set -gx PATH "$HOME/.cargo/bin" $PATH

#----- golang
set -gx GOPATH "$HOME/work/go"
set -gx PATH "$HOME/.local/go/bin" "$GOPATH/bin" $PATH

#----- homebrew
if [ $PLATFORM = "Darwin" ]
    if test -n $IS_MACOS_ARM
        eval (/opt/homebrew/bin/brew shellenv)
    else
        eval (/usr/local/Homebrew/bin/brew shellenv)
    end
end

#----- keychain agent

if type -q keychain
    if test -z "$SSH_AGENT_PID"
        eval (keychain --eval)
    end
end

#----- gcloud

if test -e $HOME/google-cloud-sdk/path.fish.inc
    source $HOME/google-cloud-sdk/path.fish.inc
end

#----- load custom settings

if test -e $HOME/.shellrc_custom.fish
    source $HOME/.shellrc_custom.fish
end

