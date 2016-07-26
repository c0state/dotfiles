#!/usr/bin/env python3

import mmap
from optparse import OptionParser
import os
import platform

_system_name_osx = 'Darwin'
_system_name_linux = 'Linux'
_system_name = platform.system()
_shell_path = os.environ['SHELL']


def file_contains_str(file_name, search_str):
    with open(file_name, 'rb', 0) as file, \
         mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_READ) as file_str:
        return file_str.find(str.encode(search_str)) != -1


def append_to_file(file_name, str):
    with open(file_name, 'a') as file:
        file.write(str)


def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--user", default="default")
    return parser.parse_args()


def setup_shell():
    # use homebrew's zsh when on OS X
    if _system_name == _system_name_osx:
        target_shell = "/usr/local/bin/zsh"
        if not file_contains_str('/etc/shells', target_shell):
            os.system('''sudo bash -c \'(echo "{}" >> /etc/shells)\''''
                      .format(target_shell))
    else:
        target_shell = "zsh"

    if target_shell != _shell_path:
        os.system("chsh -s ".format(target_shell))


def setup_vim():
    if not os.path.exists(os.path.expanduser("~/.vim/bundle/vundle.vim")):
        os.system("git clone https://github.com/vundlevim/vundle.vim "
                  "~/.vim/bundle/vundle.vim")
    else:
        print("vundle already installed")

    os.system("vim +PluginInstall +PluginUpdate + PluginClean +qall")

    os.system("(cd ~/.vim/bundle/YouCompleteMe && ./install.py "
              "--clang-completer --omnisharp-completer --gocode-completer)")


if __name__ == '__main__':
    (options, args) = parse_options()

    setup_shell()
    setup_vim()
