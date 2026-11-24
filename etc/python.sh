#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin) PLATFORM=macos ;;
  Linux) PLATFORM=linux ;;
  MINGW*|MSYS*) PLATFORM=windows ;;
  *)
    printf 'Unsupported platform: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac

DEFAULT_PYTHON_VENV_NAME="default_python_venv"
PYTHON_VERSION=3.14
REINSTALL_TOOLS=${REINSTALL_TOOLS:-""}

DEFAULT_VENV_PATH="$HOME/.local/share/python-venvs/$DEFAULT_PYTHON_VENV_NAME"

if [[ "$PLATFORM" == "windows" ]]; then
  VENV_PYTHON_PATH="$DEFAULT_VENV_PATH/Scripts/python.exe"
else
  VENV_PYTHON_PATH="$DEFAULT_VENV_PATH/bin/python"
fi

CURRENT_PYTHON_VERSION=""
if [[ -x "$VENV_PYTHON_PATH" ]]; then
  CURRENT_PYTHON_VERSION=$("$VENV_PYTHON_PATH" --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
fi

if [[ -n "$REINSTALL_TOOLS" ]] || { [[ -n "$CURRENT_PYTHON_VERSION" ]] && [[ "$CURRENT_PYTHON_VERSION" != "$PYTHON_VERSION" ]]; }; then
  rm -rf "$DEFAULT_VENV_PATH"
fi

#---------- uv

if [[ "$PLATFORM" == "windows" && -z "${UV_PYTHON_INSTALL_DIR:-}" ]]; then
  UV_PYTHON_INSTALL_DIR="$(cygpath --windows "$HOME/.local/share/uv/python")"
  if ! setx.exe UV_PYTHON_INSTALL_DIR "$UV_PYTHON_INSTALL_DIR" >/dev/null; then
    printf 'Could not persist UV_PYTHON_INSTALL_DIR for future uv commands.\n' >&2
  fi
  export UV_PYTHON_INSTALL_DIR
fi

if ! command -v uv >/dev/null 2>&1; then
  if [[ "$PLATFORM" == "windows" ]]; then
    powershell.exe -ExecutionPolicy ByPass -Command 'irm https://astral.sh/uv/install.ps1 | iex'
    UV_BIN_PATH="$(cygpath --unix "${USERPROFILE:?}/.local/bin")"
    PATH="$UV_BIN_PATH:$PATH"
  else
    curl -LsSf https://astral.sh/uv/install.sh | sh
    PATH="$HOME/.local/bin:$PATH"
  fi
  export PATH
elif [[ "$PLATFORM" != "windows" ]]; then
  uv self update
fi

UV_TOOL_BIN_PATH="$(uv tool dir --bin)"
if [[ "$PLATFORM" == "windows" ]]; then
  UV_TOOL_BIN_PATH="$(cygpath --unix "$UV_TOOL_BIN_PATH")"
fi
PATH="$UV_TOOL_BIN_PATH:$PATH"
export PATH

#---------- set up default python venv

uv python install "$PYTHON_VERSION"
uv python pin "$PYTHON_VERSION" --global

if [[ ! -d "$DEFAULT_VENV_PATH" ]]; then
  uv venv "$DEFAULT_VENV_PATH" --python "$PYTHON_VERSION"
fi

uv python upgrade

#---------- pip packages

# Install packages into the default virtualenv
uv pip install -p "$DEFAULT_VENV_PATH" --upgrade pip setuptools
uv pip install -p "$DEFAULT_VENV_PATH" --upgrade \
  jedi \
  pynvim \
  pytest \
  build twine

#---------- uv tools

if [[ "$PLATFORM" != "windows" ]]; then
  uv tool install --force --with-executables-from ansible-core ansible
fi
uv tool install --force autoenv
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

uv tool install --force poetry
poetry config virtualenvs.in-project true

uv tool install --force pre-commit
uv tool install --force ptpython
uv tool install --force pyright
uv tool install --force pyupgrade
if [[ "$PLATFORM" != "windows" ]]; then
  uv tool install --force ranger-fm
fi
uv tool install --force ruff
uv tool install --force semgrep
uv tool install --force snakeviz
if [[ "$PLATFORM" == "linux" ]]; then
  uv tool install --force s-tui
fi
uv tool install --force tox
uv tool install --force twine
uv tool install --force yt-dlp

#---------- upgrade all uv tools

uv tool upgrade --all
