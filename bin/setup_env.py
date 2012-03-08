#!/usr/bin/env python

import os
import getpass
from optparse import OptionParser

def parse_options():
    global options, args

    parser = OptionParser()
    parser.add_option("-u", "--github_username", default = getpass.getuser())

    (options, args) = parser.parse_args()

if __name__ == '__main__':
    parse_options()

    if not os.path.exists(os.path.expanduser('~/.oh-my-zsh')):
        os.system('git clone https://%(user)s@github.com/%(user)s/oh-my-zsh.git ~/.oh-my-zsh' % { 'user' : options.github_username } )
    if not os.path.exists(os.path.expanduser('~/.tmuxinator')):
        os.system('git clone https://%(user)s@github.com/%(user)s/tmuxinator.git ~/.tmuxinator' % { 'user' : options.github_username } )
