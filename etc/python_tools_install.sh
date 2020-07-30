#!/usr/bin/env bash

PLATFORM=`uname`

set -ex

python3 -m pip install --upgrade --user pip setuptools
python3 -m pip install --upgrade --user pipx

# pipx dependencies

# macOS Docker app includes docker-compose
if [[ $PLATFORM != 'Darwin' ]]; then
    pipx install docker-compose
    pipx install neovim
fi

pipx install ansible
pipx install ansible-toolkit
pipx install autoenv
pipx install black
pipx install cdiff
pipx install codemod
pipx install cookiecutter
pipx install csvkit
pipx install cwlref-runner
pipx install fourmat
pipx install howdoi
pipx install httpie
pipx install ipython
pipx install --include-deps jupyter
pipx install markdown
pipx install mypy
pipx install pipenv
pipx install pip-tools
pipx install poetry
pipx install pre-commit
pipx install ptpython
pipx install pythonpy
pipx install pyupgrade
pipx install ranger-fm
pipx install snakeviz
pipx install spleeter
pipx install tox

pipx upgrade-all

# pip dependencies

python -m pip install --user --upgrade pynvim
