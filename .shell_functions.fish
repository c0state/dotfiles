function download_all_user_repos
  set GITHUB_USER $argv[1]
  set API_URL "https://api.github.com/users/$GITHUB_USER/repos"

  for url in (curl -s $API_URL | jq -r '.[].html_url')
    git clone $url $GITHUB_USER/(string match -r '.*\/(.*)' "$url" | tail -n 1)
  end
end

function google_chrome_no_security
    open -na Google\ Chrome --args --user-data-dir=/tmp/temporary-chrome-profile-dir \
        --disable-web-security --disable-site-isolation-trials
end

function get_process_for_port
    # TODO: only works on linux currently

    if test -z "$argv"
        echo "Please specify port to check"
        return
    end
    lsof -nP -iTCP:$argv
end

function gi
    curl -L -s https://www.gitignore.io/api/$argv
end

function git_untracked_local_branches_show 
    git branch --format "%(refname:short) %(upstream)"
end

function kll
    eval kail (k get pods | grep "$argv[1]" | cut -d" " -f1 | sd -- '(?P<pod>.*)\n' '--pod $pod ') $argv[2..-1]
end

function pprint_csv 
    # pretty print csv files
    csvlook "$argv" | less -#2 -N -S
end

function pprint_json 
    # pretty print json files
    cat $argv | python -m json.tool | less -i
end

function pprint_xml 
    cat $argv | xmllint --format - 2>&1 | less -i
end

function s3_path_size
    aws s3 ls --summarize --human-readable --recursive $argv
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
    wget -O "$TEMP_PKG_INSTALL_FILE" "$argv" && sudo dpkg -i "$TEMP_PKG_INSTALL_FILE" || true
    rm -f "$TEMP_PKG_INSTALL_FILE"
    set --erase TEMP_PKG_INSTALL_FILE
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
