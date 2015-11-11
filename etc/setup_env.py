#!/usr/bin/env python

import os
import getpass
from optparse import OptionParser


def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--github_username", default=getpass.getuser())

    return parser.parse_args()


def run_command(command, error_message):
    if not os.path.exists(os.path.expanduser('~/.oh-my-zsh')):
        os.system(command)
    else:
        print(error_message)


if __name__ == '__main__':
    (options, args) = parse_options()

    if not os.path.exists(os.path.expanduser('~/.oh-my-zsh')):
        os.system('git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh')
    else:
        print('oh-my-zsh already installed')

    if not os.path.exists(os.path.expanduser('~/.tmuxinator')):
        os.system('git clone git@github.com:%(user)s/tmuxinator.git ~/.tmuxinator' % {'user': options.github_username})
    else:
        print('tmuxinator already installed')

    if not os.path.exists(os.path.expanduser('~/.vim/bundle/vundle')):
        os.system('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
    else:
        print('vundle already installed')

    os.system('''(cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --omnisharp-completer --gocode-completer)''')
