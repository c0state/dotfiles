#!/usr/bin/env python3

# TODO: NO LONGER USED, REMOVE!!!

import os
import platform
from optparse import OptionParser

_system_name_osx = "Darwin"
_system_name_linux = "Linux"
_system_name = platform.system()
_shell_path = os.environ["SHELL"]


def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--user", default="default")
    return parser.parse_args()


def setup_divvy():
    if _system_name == _system_name_osx:
        os.system("open -a Safari `cat ~/.dotfiles/osx_configs/divvy_export.txt`")


def setup_rbenv():
    if not os.path.exists(os.path.expanduser("~/.rbenv")):
        os.system("""git clone https://github.com/rbenv/rbenv.git ~/.rbenv""")
        os.system("""cd ~/.rbenv && src/configure && make -C src""")
        os.system("""~/.rbenv/bin/rbenv init""")
        os.system(
            """git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build"""
        )


if __name__ == "__main__":
    (options, args) = parse_options()

    setup_rbenv()

    if _system_name == _system_name_osx:
        setup_divvy()
