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
