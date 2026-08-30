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

## Git operations

- Never force-push (`git push --force` or `--force-with-lease`), including
  amending/rebasing an already-pushed commit and pushing the result, unless
  I explicitly tell you to do so for that specific push. This applies even
  to your own draft/unreviewed PR branches — ask first, don't assume it's
  low-risk.

## Code style

- Indent with **spaces, never tabs** — for all code, config, and markup,
  including formats commonly written with tabs (e.g. Caddyfile).
- Exception: only use tabs where the format *requires* them — Makefile
  recipes and Go source (`gofmt`). Match an existing file's indentation
  when editing it.
- Comments are opt-in, not default. Only add one when the code isn't
  self-explanatory and the *why* is genuinely non-obvious (a hidden
  constraint, a workaround for a specific bug). If the code speaks for
  itself, skip the comment. When one is warranted, keep it to a single
  terse line flagging just the non-obvious part — a multi-line
  explanation belongs in the commit message or PR description.
- Never comment *what* the code does — well-named identifiers already say
  that. If it's worth explaining (context on the change, why this approach
  over another), put it in the PR description or commit message, not an
  inline comment — that's where it belongs and won't rot as the code
  around it changes.
- Don't bake ticket/issue references (e.g. `C3D-2520:`, `JIRA-123`) into
  code comments unless explicitly asked to. Tickets get closed/renumbered
  and the reference rots; put that context in the commit message or PR
  description instead, where it belongs with the change's history.

## CLI commands

- Always use long-form flags (e.g. `--verbose` instead of `-v`) when
  running CLI commands. They're self-documenting when read back later,
  in logs, or in shared command history.

## Configuration changes

- When adding or changing configuration in this repo (setup scripts,
  settings files, service definitions, etc.), follow the existing
  conventions already used in that file rather than introducing a new
  style — e.g. in `etc/agent_setup.sh`: idempotent guards before
  install/write steps, `case "$(uname -s)" in Linux|Darwin)` blocks for
  OS-specific logic.

## Secrets

- This dotfiles repo is **public** (`github.com/c0state/dotfiles`). Never
  put a credential in a tracked file — not as a default, not as an
  example, not "temporarily".
- Machine-local secrets live outside the repo, as plain `export`s in
  `~/.shellrc_custom.sh` (bash/zsh) and `~/.shellrc_custom.fish` (fish).
  These are sourced by `.shell_interactive.sh` and
  `.config/fish/config.fish`.
- A setup script that needs a secret should source
  `~/.shellrc_custom.sh` itself — scripts run non-interactively, so it is
  not already loaded — and no-op when the variable is unset. Never
  prompt for a secret, and never hardcode a fallback value.
- Wrap secret handling in `set +x` / `set -x`. `etc/agent_setup.sh` runs
  under `set -eux`, so an unguarded assignment echoes the value.
