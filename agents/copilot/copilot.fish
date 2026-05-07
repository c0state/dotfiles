# Copilot CLI wrapper: auto-resume the pinned session for this directory.
#
# Companion to ~/.dotfiles/agents/copilot/extensions/session-pin/extension.mjs.
# If the cwd contains a .agent_session_copilot file (a Copilot session id), this
# wrapper prepends `--resume=<id>` so the next `copilot` invocation continues
# that session. The session-pin extension creates the pin file on first run and
# warns if the active session id doesn't match the pin (i.e. the wrapper isn't
# active).
#
# To enable: `source ~/.dotfiles/agents/copilot/copilot.fish` from your fish
# config (e.g. ~/.config/fish/config.fish), AFTER any `alias copilot=...` line
# so this function shadows it. The previous alias's flags are preserved here.

function copilot --description "copilot CLI with per-cwd session pin auto-resume"
    set --local pin_file .agent_session_copilot
    set --local extra_args

    # Skip auto-resume if the user already selected a session explicitly, or
    # if they're invoking a subcommand (commander-style: first arg is a bare
    # word, e.g. `copilot mcp list`). Flags-with-values like `-p hello` keep
    # auto-resume enabled.
    set --local skip_auto_resume 0
    if test (count $argv) -gt 0
        set --local first $argv[1]
        if not string match --quiet -- '-*' $first
            set skip_auto_resume 1
        end
    end
    if test $skip_auto_resume -eq 0
        for arg in $argv
            switch $arg
                case --resume '--resume=*' --continue --connect '--connect=*'
                    set skip_auto_resume 1
                    break
            end
        end
    end

    if test $skip_auto_resume -eq 0; and test -r $pin_file
        set --local pinned (string trim < $pin_file)
        if test -n "$pinned"
            set extra_args --resume=$pinned
        end
    end

    # Preserve the flags from the original alias in ~/.shell_aliases.
    command copilot --experimental --mode autopilot $extra_args $argv
end
