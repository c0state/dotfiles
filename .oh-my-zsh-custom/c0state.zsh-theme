# Personalized!

# Grab the current date (%D) and time (%T) wrapped in {}: {%D %T}
DALLAS_CURRENT_TIME_="%{$FG[198]%}[%D{%Y-%m-%d %H:%M:%S}]%{$reset_color%}"
# Grab the current version of ruby in use (via RVM)
DALLAS_CURRENT_RUBY_="%{$fg[white]%}[%{$fg[magenta]%}rbenv:\$(rbenv version | cut -f 1 -d ' ')%{$fg[white]%}]%{$reset_color%}"
# Grab the current version of python in use (via pyenv)
DALLAS_CURRENT_PYTHON_="%{$fg[white]%}[%{$fg[magenta]%}pyenv:\$(pyenv version | cut -f 1 -d ' ')%{$fg[white]%}]%{$reset_color%}"
# Grab the current version of golang in use (via gvm)
DALLAS_CURRENT_GOLANG_="%{$fg[white]%}[%{$fg[magenta]%}gvm:\$(gvm-prompt)%{$fg[white]%}]%{$reset_color%}"
# Grab the current machine name
DALLAS_CURRENT_MACH_="%{$fg[blue]%}%B%m%b%{$fg[green]%}%{$reset_color%}"
# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository: ~aw@master
DALLAS_CURRENT_LOCA_="%{$fg[green]%}[%U%/%u]\$(git_prompt_info)%{$reset_color%}"
# Grab the current username: dallas
DALLAS_CURRENT_USER_="%{$fg[white]%}%n%{$reset_color%}"
# Use a % for normal users and a # for privelaged (root) users.
DALLAS_PROMPT_CHAR_="
%{$fg[white]%}>%{$reset_color%}"
# For the git prompt, use a white @ and blue text for the branch name
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}@%{$FG[190]%}"
# Close it all off by resetting the color and styles.
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN=""
# Add 3 cyan ✗s if this branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}✗✗✗"

# Put it all together!
PROMPT="$DALLAS_CURRENT_TIME_$DALLAS_CURRENT_USER_@$DALLAS_CURRENT_MACH_$DALLAS_CURRENT_LOCA_$DALLAS_CURRENT_PYTHON_$DALLAS_CURRENT_RUBY_$DALLAS_CURRENT_GOLANG_$DALLAS_PROMPT_CHAR_ "

