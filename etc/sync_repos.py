#!/usr/bin/env python

# This script syncs the external repos used by these dotfiles (e.g.: oh-my-zsh, vundle, etc.)

import os
import getpass
from optparse import OptionParser

repos = ('~/.oh-my-zsh', '~/.vim/bundle/vundle')

if __name__ == '__main__':
    for repo in repos:
        print("---------- Updating repo [%s]" % (repo))
        os.system('(cd %s && git pull)' % (repo))
        print("---------- Done updating repo [%s]" % (repo))
