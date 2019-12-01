#!/usr/bin/env bash

PLATFORM=`uname`

set -ex

python3 -m pip install --upgrade --user pip setuptools
python3 -m pip install --upgrade --user pipx

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
pipx install cookiecutter
pipx install csvkit
pipx install fourmat
pipx install howdoi
pipx install httpie
pipx install ipython
pipx install --include-deps jupyter
pipx install markdown
pipx install mypy
# pipx install pynvim
pipx install pipenv
pipx install pip-tools
pipx install poetry
pipx install ptpython
pipx install pythonpy
pipx install pyupgrade
pipx install ranger-fm

pipx upgrade-all
