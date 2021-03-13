#----- detect platform
set PLATFORM `uname`

alias diff="colordiff --side-by-side --suppress-common-lines"
alias dbox="dropbox.py"

# docker aliases
alias docker_stop_containers='docker stop (docker ps -a -q)'
alias docker_kill_containers='docker kill (docker ps -q)'
alias docker_rm_containers='docker rm (docker ps -a -q)'
alias docker_rm_images='docker rmi (docker images -q)'
alias docker_purge_system='docker system prune --all --force --volumes'

alias fd="fd --hidden"
which fdfind &>/dev/null && alias fd="fdfind --hidden"
alias findforks="find . -type f -exec test -s {}/..namedfork/rsrc \; -print"
alias fzf="fzf --preview 'head -100 {}'"

alias gitdt="git difftool "
alias gitvdiff="git difftool -t tkdiff --no-prompt"
alias git_prune_empty_dirs="find . -name .git -prune -o -type d -empty -print | xargs rmdir -p || true"

alias grep="egrep"
alias h="history"
alias hg="history | grep"
alias less="less -i --chop-long-lines --shift 2"
alias ls="lsd"
alias mdv="$HOME/.terminal_markdown_viewer/mdv.py"
alias mysql.start="/opt/local/share/mysql5/mysql/mysql.server"

alias psg="ps aux | grep"
alias rg="rg --hidden --pretty --sort path"
alias sort_latest='find . -type f -exec stat --format "%Y - %y --> %n" "{}" \; | sort -n'
alias tree="tree --dirsfirst"
alias vi="nvim"
alias vim="nvim"

if test -e ~/.shell_aliases_custom
    source ~/.shell_aliases_custom
end
