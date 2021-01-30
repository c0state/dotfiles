#!/usr/bin/env python3

import mmap
from optparse import OptionParser
import os
import platform

_system_name_osx = "Darwin"
_system_name_linux = "Linux"
_system_name = platform.system()
_shell_path = os.environ["SHELL"]


def file_contains_str(file_name, search_str):
    with open(file_name, "rb", 0) as file, mmap.mmap(
        file.fileno(), 0, access=mmap.ACCESS_READ
    ) as file_str:
        return file_str.find(str.encode(search_str)) != -1


def append_to_file(file_name, str):
    with open(file_name, "a") as file:
        file.write(str)


def symlink_dotfile(source, target, overwrite=False, backup=False):
    force = "-f" if overwrite else ""
    do_backup = "-b" if backup else ""
    if not os.path.exists(target) or overwrite:
        os.system(f"""ln -s {source} {target} {force}""")


def parse_options():
    parser = OptionParser()
    parser.add_option("-u", "--user", default="default")
    return parser.parse_args()


def setup_dotfiles():
    if not os.path.exists(os.path.expanduser("""~/.dotfiles""")):
        os.system("""git clone https://github.com/c0state/dotfiles ~/.dotfiles""")
    else:
        os.system("""(cd ~/.dotfiles && git pullr)""")


def setup_shell():
    # use homebrew's zsh when on OS X
    if _system_name == _system_name_osx:
        target_shell = "/usr/local/bin/zsh"
        if not file_contains_str("/etc/shells", target_shell):
            os.system(f"""sudo bash -c \'(echo "{target_shell}" >> /etc/shells)\'""")
    else:
        target_shell = "/bin/zsh"

    if target_shell != _shell_path:
        os.system(f"chsh -s {target_shell}")


def setup_vim():
    if not os.path.exists(os.path.expanduser("~/.vim/autoload/plug.vim")):
        os.system(
            "curl -fLo ~/.vim/autoload/plug.vim --create-dirs "
            "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        )
    else:
        print("vim-plug already installed")

    os.system("vim +PlugClean +PlugInstall +PlugUpdate +qall")


def setup_macos():
    if _system_name == _system_name_osx:
        # increase mouse tracking scaling factor (default is 3 I believe)
        os.system("defaults write -g com.apple.mouse.scaling 5")


def setup_divvy():
    if _system_name == _system_name_osx:
        os.system("open -a Safari " "`cat ~/.dotfiles/osx_configs/divvy_export.txt`")


def setup_pyenv():
    if not os.path.exists(os.path.expanduser("~/.pyenv")):
        os.system("""git clone https://github.com/pyenv/pyenv ~/.pyenv""")
        os.system(
            """git clone https://github.com/pyenv/pyenv-virtualenv.git """
            """$(pyenv root)/plugins/pyenv-virtualenv"""
        )


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


def setup_apex():
    os.system(
        """curl https://raw.githubusercontent.com/apex/apex/master/"""
        """install.sh | sh"""
    )


def setup_bit():
    os.system(
        """curl -sf https://gobinaries.com/chriswalz/bit | sh; """
        """curl -sf https://gobinaries.com/chriswalz/bit/bitcomplete | sh && echo y | """
        """COMP_INSTALL=1 bitcomplete"""
    )


if __name__ == "__main__":
    (options, args) = parse_options()

    setup_dotfiles()
    setup_shell()
    setup_vim()
    setup_divvy()
    setup_pyenv()
    setup_rbenv()
    setup_gvm()
    setup_bit()
    setup_git_subrepo()
