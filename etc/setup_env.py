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


def symlink_dotfile(source, target, overwrite=False, backup=False):
    force = "-f" if overwrite else ""
    do_backup = "-b" if backup else ""
    if not os.path.exists(target) or overwrite:
        os.system("""ln -s {} {} {}""".format(source, target, force, do_backup))

def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--user", default="default")
    return parser.parse_args()


def setup_dotfiles():
    if not os.path.exists(os.path.expanduser("""~/.dotfiles""")):
        os.system("""git clone https://github.com/c0state/dotfiles"""
                  """~/.dotfiles""")
    else:
        os.system("""(cd ~/.dotfiles && git pull)""")

    # now set up links
    symlink_dotfile("~/.dotfiles/anyenv", "~/.anyenv")


def setup_shell():
    # use homebrew's zsh when on OS X
    if _system_name == _system_name_osx:
        target_shell = "/usr/local/bin/zsh"
        if not file_contains_str('/etc/shells', target_shell):
            os.system('''sudo bash -c \'(echo "{}" >> /etc/shells)\''''
                      .format(target_shell))
    else:
        target_shell = "/bin/zsh"

    if target_shell != _shell_path:
        os.system("chsh -s {}".format(target_shell))


def setup_vim():
    if not os.path.exists(os.path.expanduser("~/.vim/bundle/Vundle.vim")):
        os.system("git clone https://github.com/VundleVim/Vundle.vim "
                  "~/.vim/bundle/Vundle.vim")
    else:
        print("vundle already installed")

    os.system("vim +PluginInstall +PluginUpdate + PluginClean +qall")

    os.system("(cd ~/.vim/bundle/YouCompleteMe && ./install.py "
              "--clang-completer --omnisharp-completer --gocode-completer)")


def setup_divvy():
    if _system_name == _system_name_osx:
        os.system("open -a Safari "
                  "`cat ~/.dotfiles/osx_configs/divvy_export.txt`")


def setup_pyenv():
    if not os.path.exists(os.path.expanduser("~/.pyenv")):
        os.system("""git clone https://github.com/pyenv/pyenv ~/.pyenv""")
        os.system("""git clone https://github.com/pyenv/pyenv-virtualenv.git """
                  """$(pyenv root)/plugins/pyenv-virtualenv""")


def setup_gvm():
    if not os.path.exists(os.path.expanduser("~/.gvm")):
        os.system("""curl -s -S -L """
                  """https://raw.githubusercontent.com/moovweb/gvm/master/"""
                  """binscripts/gvm-installer """
                  """| zsh""")


def setup_git_subrepo():
    if not os.path.exists(os.path.expanduser("~/.git-subrepo")):
        os.system("""git clone https://github.com/ingydotnet/git-subrepo.git """
                  """~/.git-subrepo""")
    else:
        os.system("""(cd ~/.git-subrepo && git pull)""")


def setup_apex():
    os.system("""curl https://raw.githubusercontent.com/apex/apex/master/"""
              """install.sh | sh""")

if __name__ == '__main__':
    (options, args) = parse_options()

    setup_dotfiles()
    setup_shell()
    setup_vim()
    setup_divvy()
    setup_pyenv()
    setup_gvm()
    setup_git_subrepo()
