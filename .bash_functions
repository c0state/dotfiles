function bash_colors {
    # output bash supported colors and their code
	for i in {0..255} ; do printf "\x1b[38;5;${i}mcolour${i}\n" ; done
}

function cat_video {
    # concatenate 2 or more video files using ffmpeg (requires zsh)

    args=("$@")
    args_len=$(($# - 1))
    args_array_minus_last=("${@:1:$args_len}")
    last_arg="last=${@[$#]}"
    ffmpeg -f concat -i <(for f in ${args_array_minus_last[@]}; do echo "file '$PWD/$f'"; done) -c copy "$last_arg"
}

function findnewest {
    if [[ $1 != "" ]]; then
      num_items_to_show="-n $1"
    fi
    find . -type f -printf '%T+ %p\n' | sort -r | head $num_items_to_show ;
}

function fixinsecurecompaudit {
    # fixes "insecure compinit warnings in zsh"

	compaudit | xargs chgrp Users
	compaudit | xargs chmod g-w
	rm -f ~/.zcompdump*
	compinit
}

function gi() { curl -L -s https://www.gitignore.io/api/$@ ; }

function git_untracked_local_branches_show {
    # output all untracked local branches in current repo
    git fetch --all --prune --quiet

    git branch -r |
    awk '{print $1}' |
    egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) |
    awk '{print $1}' |
    xargs echo
}

function git_pr_merge_review {
    pr_branch_name="pr_$1"
    git checkout -b pr_review/$pr_branch_name
    git fetch upstream pull/"$1"/head:$pr_branch_name
    git merge $pr_branch_name --no-commit --no-ff 
    git difftool --cached
    git merge --abort
    git branch -D $pr_branch_name
}

function git_clean_local {
    git reset HEAD -- ...
    git clean -d -f ...
    git checkout -- ...
}

function logcat { adb logcat -d -v time ; }

function pprint_csv {
    # pretty print csv files
    csvlook "$1" | less -#2 -N -S
}

function pprint_json {
    # pretty print json files
    cat "$1" | python -m json.tool | less -i
}

function pprint_xml {
    cat "$1" | xmllint --format - 2>&1 | less -i
}

function runnew { nohup "$*" 1>/dev/null 2>&1 </dev/null ; }

function strip_comments_blank_lines {
    if [ $# -eq 0 ]; then
      \grep -v -E "\s*#|^\s*$" </dev/stdin
    else
      \grep -v -E "\s*#|^\s*$" "$*"
    fi
}
