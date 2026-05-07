# Copilot CLI wrapper: auto-resume the pinned session for this directory.
#
# zsh sibling of ~/.dotfiles/agents/copilot/copilot.fish. To enable in zsh:
#   source ~/.dotfiles/agents/copilot/copilot.zsh
# (load it after any `alias copilot=...` so the function shadows it).

copilot() {
    local pin_file=".agent_session_copilot"
    local -a extra_args
    local skip_auto_resume=0

    # Subcommand detection: first arg is a bare word (no leading dash).
    if [[ $# -gt 0 && ${1:0:1} != "-" ]]; then
        skip_auto_resume=1
    fi

    if (( skip_auto_resume == 0 )); then
        for arg in "$@"; do
            case $arg in
                --resume|--resume=*|--continue|--connect|--connect=*)
                    skip_auto_resume=1
                    break
                    ;;
            esac
        done
    fi

    if (( skip_auto_resume == 0 )) && [[ -r $pin_file ]]; then
        local pinned
        pinned=$(< $pin_file)
        pinned=${pinned//[[:space:]]/}
        if [[ -n $pinned ]]; then
            extra_args=(--resume=$pinned)
        fi
    fi

    # Preserve the flags from the original alias in ~/.shell_aliases.
    command copilot --experimental --mode autopilot "${extra_args[@]}" "$@"
}
