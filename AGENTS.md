# User Instructions

Personal, machine-wide, agent-agnostic instructions. Canonical source is
`~/.dotfiles/AGENTS.md`; Claude loads it via `~/.claude/CLAUDE.md` (which
`@import`s this file). Synced across machines via the dotfiles repo.

## Branch naming

Use [Conventional Commits](https://www.conventionalcommits.org/en/)
types as the branch prefix, followed by a short kebab-case description:

```
<type>/<short-description>
```

Allowed types:

| Type       | Purpose                                          |
|------------|--------------------------------------------------|
| `feat`     | New feature                                      |
| `fix`      | Bug fix                                          |
| `docs`     | Documentation only                               |
| `style`    | Formatting, whitespace — no logic change         |
| `refactor` | Code restructuring — no feature or fix           |
| `perf`     | Performance improvement                          |
| `test`     | Adding or updating tests                         |
| `build`    | Build system or dependency changes               |
| `ci`       | CI/CD configuration                              |
| `chore`    | Maintenance tasks that don't fit other types     |

Rules:
- Keep the description to 2–4 words in kebab-case.
- Examples: `feat/add-oauth-login`, `fix/null-pointer-crash`,
  `docs/update-readme`, `refactor/extract-auth-module`.
- When creating a PR branch, always follow this convention.

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
