#---------- constants

# platform
set --local PLATFORM (uname)
set --local IS_MACOS_ARM (uname -a | grep -i "darwin.*arm64" || echo "")

# misc
set --local REPORTTIME 3

#---------- aliases and functions

source ~/.shell_aliases.fish
source ~/.shell_functions.fish

#---------- homebrew
if [ $PLATFORM = "Darwin" ]
    if test -n $IS_MACOS_ARM
        eval (/opt/homebrew/bin/brew shellenv)
    else
        eval (/usr/local/Homebrew/bin/brew shellenv)
    end
end

#---------- paths

set -gx PATH $PATH ~/.local/bin;

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

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
    status is-login; and pyenv init --path | source
end

#----- rust
set -gx PATH "$HOME/.cargo/bin" $PATH

#----- golang
set -gx GOPATH "$HOME/work/go"
set -gx PATH "$HOME/.local/go/bin" "$GOPATH/bin" $PATH

#----- chia crypto
set -gx PATH $PATH "/Applications/Chia.app/Contents/Resources/app.asar.unpacked/daemon"

#----- kubectl krew
set -gx PATH $PATH $HOME/.krew/bin

#---------- keychain agent

if type -q keychain
    eval (keychain --eval 2>/dev/null)
end

#---------- gcloud

if test -e $HOME/google-cloud-sdk/path.fish.inc
    source $HOME/google-cloud-sdk/path.fish.inc
end

#---------- load custom settings

if test -e $HOME/.shellrc_custom.fish
    source $HOME/.shellrc_custom.fish
end

#---------- prompt

starship init fish | source

