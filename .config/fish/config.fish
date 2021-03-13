#---------- aliases and functions

source ~/.shell_aliases.fish
source ~/.shell_functions.fish

#---------- prompt

starship init fish | source

#---------- paths

set PATH $PATH ~/.local/bin;
