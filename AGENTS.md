# User Instructions

Personal, machine-wide, agent-agnostic instructions. Canonical source is
`~/.dotfiles/AGENTS.md`; Claude loads it via `~/.claude/CLAUDE.md` (which
`@import`s this file). Synced across machines via the dotfiles repo.

## Code style

- Indent with **spaces, never tabs** — for all code, config, and markup,
  including formats commonly written with tabs (e.g. Caddyfile).
- Exception: only use tabs where the format *requires* them — Makefile
  recipes and Go source (`gofmt`). Match an existing file's indentation
  when editing it.
- Comments are opt-in, not default. Only add one when the code isn't
  self-explanatory and the *why* is genuinely non-obvious (a hidden
  constraint, a workaround for a specific bug). If the code speaks for
  itself, skip the comment.

## Configuration changes

- When adding or changing configuration in this repo (setup scripts,
  settings files, service definitions, etc.), follow the existing
  conventions already used in that file rather than introducing a new
  style — e.g. in `etc/agent_setup.sh`: idempotent guards before
  install/write steps, `case "$(uname -s)" in Linux|Darwin)` blocks for
  OS-specific logic.
