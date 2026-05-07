# copilot session-pin

Pin a `copilot` CLI session to a directory. Re-running `copilot` from that
directory automatically resumes the same session, so you can pop in/out of
projects without losing context.

## Pieces

- **`extensions/session-pin/extension.mjs`** — Copilot CLI extension. On every
  session start, looks for `.agent_session_copilot` in the cwd and:
  - If absent: writes the active session ID to it.
  - If present and matches the active session: silent (the wrapper resumed
    correctly).
  - If present but mismatched: logs a warning, leaves the file untouched.

  Only handles the **save** half. The actual `--resume` must happen *before*
  `copilot` launches — the extension's `onSessionStart` hook runs after the
  session has already been attached, and hooks can only inject context, not
  redirect.

- **`copilot.fish`** / **`copilot.zsh`** — shell wrappers that handle the
  **resume** half. If `.agent_session_copilot` exists in the cwd and the user
  hasn't already passed `--resume` / `--continue` / `--connect` / a
  subcommand, the wrapper prepends `--resume=<pinned-id>` before invoking the
  real `copilot` binary.

## Install

Everything is wired up by the dotfiles already:

- **Extension** — `etc/agent_setup.sh` creates `~/.copilot/extensions/session-pin/`
  and symlinks `extension.mjs` into it. (The parent must be a real directory:
  Copilot's discovery uses `readdir({withFileTypes:true})` and skips symlinked
  subdirs because `Dirent.isDirectory()` is false for symlinks. The inner
  `extension.mjs` check uses `stat()` and follows symlinks fine.)
- **fish wrapper** — sourced from `.config/fish/config.fish`.
- **zsh wrapper** — sourced from `.zshrc` (after `.shell_interactive.sh`, so it
  shadows any `alias copilot=...`).

So a fresh setup is just:

```sh
~/.dotfiles/etc/agent_setup.sh
```

## Usage

```fish
cd ~/some/project
copilot                  # creates .agent_session_copilot with the session id
# ...later, fresh shell, same dir:
copilot                  # auto-resumes the pinned session
copilot -p "do thing"    # also auto-resumes (one-shot turn against pinned session)
copilot --continue       # bypasses the pin (uses copilot's own most-recent logic)
copilot mcp list         # subcommand: pin ignored
```

To unpin, just `rm .agent_session_copilot`.
