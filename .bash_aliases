#----- detect platform
PLATFORM=`uname`

alias diff="colordiff --side-by-side --suppress-common-lines"
alias dbox="dropbox.py"
alias findforks="find . -type f -exec test -s {}/..namedfork/rsrc \; -print"
alias fzf="fzf --preview 'head -100 {}'"
alias gitdt="git difftool "
alias gitvdiff="git difftool -t tkdiff --no-prompt"
alias grep="egrep"
alias h="history"
alias hg="history | grep"
alias less="less -i --chop-long-lines --shift 2"

# oh-my-zsh adds -G option so we need to unset it to use lsd, exa, etc.
alias ls="ls"

alias mdv="$HOME/.terminal_markdown_viewer/mdv.py"
alias mysql.start="/opt/local/share/mysql5/mysql/mysql.server"
alias psg="ps aux | grep"
alias runtest="nohup '$*' 1>/dev/null 2>&1 </dev/null &"
alias sort_latest='find . -type f -exec stat --format "%Y - %y --> %n" "{}" \; | sort -n'
alias tree="tree --dirsfirst"

if [[ -e ~/.bash_aliases_custom ]]; then
    source ~/.bash_aliases_custom
fi

