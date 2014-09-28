#----- detect platform
PLATFORM=`uname`

alias dbox="dropbox.py"
alias findforks="find . -type f -exec test -s {}/..namedfork/rsrc \; -print"
alias gitdt="git difftool "
alias gitvdiff="git difftool -t tkdiff --no-prompt"
alias grep="egrep"
alias h="history"
alias hg="history | grep"
alias mysql.start="/opt/local/share/mysql5/mysql/mysql.server"
alias psg="ps aux | grep"
alias runtest="nohup '$*' 1>/dev/null 2>&1 </dev/null &"
alias sort_latest='find . -type f -exec stat --format "%Y - %y --> %n" "{}" \; | sort -n'
alias tmuxinator='~/.tmuxinator/bin/tmuxinator'
