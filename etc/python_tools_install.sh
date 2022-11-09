#!/usr/bin/env bash

set -eux

if [[ ! -e "$HOME/.pyenv" ]]; then
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
else
    pyenv update
fi

if ! command -v poetry; then
    curl -sSL https://install.python-poetry.org | python3 -
    poetry config virtualenvs.in-project true
else
    poetry self update
fi

#---------- pip packages

pip3 install --upgrade --user pip setuptools
pip3 install --upgrade --user pipx

pip3 install --upgrade --user openai
pip3 install --upgrade --user jedi
pip3 install --upgrade --user pynvim

#---------- pipx dependencies

which ansible || pipx install --include-deps ansible
which black || pipx install --include-deps black
which activate.sh || pipx install autoenv
which cdiff || pipx install cdiff
which codemod || pipx install codemod
which cookiecutter || pipx install cookiecutter
which csvformat || pipx install csvkit
which cwl-runner || pipx install cwlref-runner
which cwltool || pipx install cwltool
which dbt || pipx install --include-deps dbt-core
which git-dmb || pipx install git-delete-merged-branches
which howdoi || pipx install howdoi
which http || pipx install httpie
which ipython || pipx install ipython
which markdown_py || pipx install markdown
which mypy || pipx install mypy
which pgcli || pipx install pgcli
which pip-compile || pipx install pip-tools
which pipdeptree || pipx install pipdeptree
which pipenv || pipx install pipenv
which pre-commit || pipx install pre-commit
which ptpython || pipx install ptpython
which pyupgrade || pipx install pyupgrade
which ranger || pipx install ranger-fm
which semgrep || pipx install semgrep
which snakeviz || pipx install snakeviz
which tox || pipx install tox
which twine || pipx install twine
which youtube-dl || pipx install youtube-dl

#---------- upgrade all pipx packages

pipx upgrade-all

