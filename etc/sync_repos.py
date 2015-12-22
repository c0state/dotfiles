#!/usr/bin/env python

# This script syncs the external repos used by these dotfiles
# (e.g.: oh-my-zsh, vundle, etc.)

import os

repos = {
    '~/.oh-my-zsh': 'https://github.com/robbyrussell/oh-my-zsh.git',
    '~/.vim/bundle/vundle.vim':
        'https://github.com/VundleVim/Vundle.vim.git',
    '~/.z.git': 'https://github.com/rupa/z.git',
}


def clone_tools_repos():
    for (repo_dir, repo_github_url) in repos.iteritems():
        repo_dir = os.path.expanduser(repo_dir)
        if not os.path.exists(repo_dir):
            os.system('git clone {} {}'.format(repo_github_url, repo_dir))


def pull_tools_repos():
    for (repo_dir, repo_github_url) in repos.iteritems():
        print("---------- Updating repo [{}] from [{}]".format(
            repo_dir, repo_github_url))
        os.system('(cd {} && git pull)'.format(repo_dir))
        print("---------- Done updating repo [{}]".format(repo_dir))

if __name__ == '__main__':
    clone_tools_repos()
    pull_tools_repos()
