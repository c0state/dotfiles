function get_process_for_port
    # TODO: only works on linux currently

    if test -z "$1"
        echo "Please specify port to check"
        return
    end
    lsof -nP -iTCP:$1
end

function gi
    curl -L -s https://www.gitignore.io/api/$argv
end

function git_untracked_local_branches_show 
    git branch --format "%(refname:short) %(upstream)"
end

function pprint_csv 
    # pretty print csv files
    csvlook "$1" | less -#2 -N -S
end

function pprint_json 
    # pretty print json files
    cat "$1" | python -m json.tool | less -i
end

function pprint_xml 
    cat "$1" | xmllint --format - 2>&1 | less -i
end

function strip_comments_blank_lines
    \grep -v -E "\s*#|^\s*\$" "$argv"
end

function sync_emulator_time 
    adb -e shell su root date `date +"%m%d%H%M%y"`
end

# ---------- linux apt

function install_package 
    set TEMP_PKG_INSTALL_FILE (mktemp)
    wget -O "$TEMP_PKG_INSTALL_FILE" "$1" && sudo dpkg -i "$TEMP_PKG_INSTALL_FILE" || true
    rm -f "$TEMP_PKG_INSTALL_FILE"
end

# ---------- macos

function divvy_export 
    if test -z $argv
        echo "Please provide filename to write divvy config to"
    else
        open -a Safari divvy://export && pbpaste > "$argv"
    end
end

function clear_macos_timemachine_snapshots 
    for curr_dir in (tmutil listlocalsnapshotdates | grep "-")
        sudo tmutil deletelocalsnapshots $curr_dir
    end
end
