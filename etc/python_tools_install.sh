#!/usr/bin/env bash

set -eux

PLATFORM=$(uname)

if [[ ! -e "$HOME/.pyenv" ]]; then
    curl --tls-max default --location https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    export PATH=$PATH:$HOME/.pyenv/bin
    eval "$(pyenv init -)"
fi

if ! command -v poetry; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - --no-modify-path
    $HOME/.poetry/bin/poetry config virtualenvs.in-project true
fi

#---------- pip packages

python3 -m pip install --upgrade --user pip setuptools
python3 -m pip install --upgrade --user pipx
python3 -m pip install --upgrade --user pynvim

#---------- pipx dependencies

if [[ $PLATFORM != 'Linux' ]]; then
    which docker-compose || pipx install docker-compose
fi

which ansible || pipx install --include-deps ansible
which activate.sh || pipx install autoenv
which cdiff || pipx install cdiff
which codemod || pipx install codemod
which cookiecutter || pipx install cookiecutter
which csvformat || pipx install csvkit
which cwl-runner || pipx install cwlref-runner
which cwltool || pipx install cwltool
which dbt || pipx install --include-deps dbt
which git-delete-merged-branches || pipx install git-delete-merged-branches
which howdoi || pipx install howdoi
which http || pipx install httpie
which ipython || pipx install ipython
which markdown_py || pipx install markdown
which mypy || pipx install mypy
which pipenv || pipx install pipenv
which pip-compile || pipx install pip-tools
which pre-commit || pipx install pre-commit
which ptpython || pipx install ptpython
which pyupgrade || pipx install pyupgrade
which ranger || pipx install ranger-fm
which snakeviz || pipx install snakeviz
which tox || pipx install tox
which twine || pipx install twine
which youtube-dl || pipx install youtube-dl

#---------- upgrade all pipx packages

pipx upgrade-all

