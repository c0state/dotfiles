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


if __name__ == "__main__":
    (options, args) = parse_options()

    if _system_name == _system_name_osx:
        setup_divvy()
