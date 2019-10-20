#!/usr/bin/env bash

set -ex

# install pip and setuptools into normal location
pip install --upgrade pip setuptools

# this is a list of pypi packages to install into system python for general use
pip install --upgrade --user ansible ansible-toolkit markupsafe
pip install --upgrade --user autoenv
pip install --upgrade --user aws-shell
pip install --upgrade --user cdiff
pip install --upgrade --user cookiecutter
pip install --upgrade --user csvkit
pip install --upgrade --user docker-compose
pip install --upgrade --user dopy
pip install --upgrade --user jedi
pip install --upgrade --user howdoi
pip install --upgrade --user http-prompt
pip install --upgrade --user httpie
pip install --upgrade --user jupyter
pip install --upgrade --user markdown
pip install --upgrade --user neovim pynvim
pip install --upgrade --user pipenv
pip install --upgrade --user pip-tools
pip install --upgrade --user ptpython
pip install --upgrade --user pythonpy
pip install --upgrade --user pyupgrade
pip install --upgrade --user pyyaml
pip install --upgrade --user ranger-fm
pip install --upgrade --user virtualenv
pip install --upgrade --user virtualenvwrapper
