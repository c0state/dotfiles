#!/usr/bin/env bash

set -eu

DEFAULT_PYTHON_VENV_NAME="default_python_venv"
PYTHON_VERSION=3.14
REINSTALL_TOOLS=${REINSTALL_TOOLS:-""}

if [[ -n "$REINSTALL_TOOLS" ]]; then
    rm -rf "$HOME"/.local/share/uv
fi

#---------- uv

if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    uv self update
fi

uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish

#---------- set up default python venv

uv python install "$PYTHON_VERSION" --default

DEFAULT_VENV_PATH="$HOME/.local/share/python-venvs/$DEFAULT_PYTHON_VENV_NAME"

if [[ ! -d "$DEFAULT_VENV_PATH" ]]; then
    uv venv "$DEFAULT_VENV_PATH" --python "$PYTHON_VERSION"
fi

uv python upgrade

#---------- pip packages

# Install packages into the default virtualenv
uv pip install -p "$DEFAULT_VENV_PATH" --upgrade pip setuptools
uv pip install -p "$DEFAULT_VENV_PATH" --upgrade \
    openai \
    jedi \
    pynvim \
    pytest \
    build twine

#---------- uv tools

uv tool install --force ansible
uv tool install --force black
uv tool install --force autoenv
uv tool install --force cdiff
uv tool install --force codemod
uv tool install --force cookiecutter
uv tool install --force csvkit
uv tool install --force cwlref-runner
uv tool install --force cwltool
uv tool install --force dbt-core
uv tool install --force git-delete-merged-branches
uv tool install --force graphtage
uv tool install --force howdoi
uv tool install --force httpie
uv tool install --force markdown
uv tool install --force mypy
uv tool install --force pgcli
uv tool install --force pip-tools
uv tool install --force pipdeptree
uv tool install --force pipenv
uv tool install --force pre-commit
uv tool install --force ptpython
uv tool install --force pyright
uv tool install --force pyupgrade
uv tool install --force ranger-fm
uv tool install --force ruff
uv tool install --force semgrep
uv tool install --force snakeviz
uv tool install --force s-tui
uv tool install --force tox
uv tool install --force twine
uv tool install --force youtube-dl
uv tool install --force yt-dlp

#---------- upgrade all uv tools

uv tool upgrade --all

