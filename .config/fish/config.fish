#---------- aliases and functions

source ~/.shell_aliases.fish
source ~/.shell_functions.fish

#---------- prompt

starship init fish | source

#---------- paths

set PATH $PATH ~/.local/bin;

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# poetry
set -gx PATH "$HOME/.poetry/bin" $PATH
