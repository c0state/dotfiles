#!/usr/bin/env bash

set -eu

DEFAULT_PYTHON_VENV_NAME="default_python_venv"
PYTHON_VERSION=3.13.4
REINSTALL_TOOLS=${REINSTALL_TOOLS:-""}

if [[ -n "$REINSTALL_TOOLS" ]]; then
    rm -rf "$HOME"/.local/pipx
    rm -rf "$HOME"/.local/bin/pipx
    rm -rf "$HOME"/.local/share/pipx
    rm -rf "$HOME"/Library/"Application Support"/pypoetry
    rm -rf "$HOME"/Library/Caches/pypoetry

    pyenv uninstall -f "$DEFAULT_PYTHON_VENV_NAME" || true
    pyenv global system
fi

#---------- pyenv

if [[ ! -e "$HOME/.pyenv" ]]; then
    curl https://pyenv.run | bash

    # init just for this session (eg: used below)
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
else
    pyenv update
fi

#---------- set up default python venv

if ! (pyenv versions | grep "$PYTHON_VERSION"); then
  pyenv install "$PYTHON_VERSION"
fi

if ! pyenv versions | grep "$DEFAULT_PYTHON_VENV_NAME"; then
  pyenv virtualenv "$PYTHON_VERSION" "$DEFAULT_PYTHON_VENV_NAME"
fi
pyenv global "$DEFAULT_PYTHON_VENV_NAME"

#---------- pip packages

pip3 install --upgrade pip setuptools
pip3 install --upgrade pipx

pip3 install --upgrade openai
pip3 install --upgrade jedi
pip3 install --upgrade pynvim

pip3 install --upgrade pytest

pip3 install --upgrade build twine

#---------- pipx dependencies

pipx install --include-deps ansible
pipx install --include-deps black
pipx install autoenv
pipx install cdiff
pipx install codemod
pipx install cookiecutter
pipx install csvkit
pipx install cwlref-runner
pipx install cwltool
pipx install --include-deps dbt-core
pipx install git-delete-merged-branches
pipx install graphtage
pipx install howdoi
pipx install httpie
pipx install markdown
pipx install mypy
pipx install pgcli
pipx install pip-tools
pipx install pipdeptree
pipx install pipenv
pipx install poetry
pipx install pre-commit
pipx install ptpython
pipx install pyright
pipx install pyupgrade
pipx install ranger-fm
pipx install ruff
pipx install semgrep
pipx install snakeviz
pipx install s-tui
pipx install tox
pipx install twine
pipx install youtube-dl
pipx install yt-dlp

#---------- poetry

poetry config virtualenvs.in-project true

#---------- upgrade all pipx packages

pipx upgrade-all

