#!/usr/bin/env python3

# TODO: NO LONGER USED, REMOVE!!!

import mmap
import os
import platform
from optparse import OptionParser

_system_name_osx = "Darwin"
_system_name_linux = "Linux"
_system_name = platform.system()
_shell_path = os.environ["SHELL"]


def file_contains_str(file_name, search_str):
    with open(file_name, "rb", 0) as file, mmap.mmap(
        file.fileno(), 0, access=mmap.ACCESS_READ
    ) as file_str:
        return file_str.find(str.encode(search_str)) != -1


def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--user", default="default")
    return parser.parse_args()


def setup_divvy():
    if _system_name == _system_name_osx:
        os.system("open -a Safari " "`cat ~/.dotfiles/osx_configs/divvy_export.txt`")


def setup_rbenv():
    if not os.path.exists(os.path.expanduser("~/.rbenv")):
        os.system("""git clone https://github.com/rbenv/rbenv.git ~/.rbenv""")
        os.system("""cd ~/.rbenv && src/configure && make -C src""")
        os.system("""~/.rbenv/bin/rbenv init""")
        os.system(
            """git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build"""
        )


def setup_gvm():
    if not os.path.exists(os.path.expanduser("~/.gvm")):
        os.system(
            """curl -s -S -L """
            """https://raw.githubusercontent.com/moovweb/gvm/master/"""
            """binscripts/gvm-installer """
            """| zsh"""
        )


def setup_git_subrepo():
    if not os.path.exists(os.path.expanduser("~/.git-subrepo")):
        os.system(
            """git clone https://github.com/ingydotnet/git-subrepo.git """
            """~/.git-subrepo"""
        )
    else:
        os.system("""(cd ~/.git-subrepo && git pull)""")


def setup_bit():
    os.system(
        """curl -sf https://gobinaries.com/chriswalz/bit | sh; """
        """curl -sf https://gobinaries.com/chriswalz/bit/bitcomplete | sh && echo y | """
        """COMP_INSTALL=1 bitcomplete"""
    )


if __name__ == "__main__":
    (options, args) = parse_options()

    setup_rbenv()
    setup_gvm()
    setup_bit()
    setup_git_subrepo()

    if _system_name == _system_name_osx:
        setup_divvy()
