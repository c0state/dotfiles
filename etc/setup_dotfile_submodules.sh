#!/usr/bin/env bash

(
    cd "$HOME"/.dotfiles &&
    git submodule update --init --recursive --remote &&
    cd "$HOME"/.dotfiles/.oh-my-zsh-custom/plugins/zsh-autocomplete &&
    # TODO: disable due to "command not found: _autocomplete.extras" error
    echo
    echo "**************************************************"
    echo Locking commit for zsh-autocompletions due to bug, see: https://github.com/marlonrichert/zsh-autocomplete/issues/81
    echo "**************************************************"
    echo
    git checkout d0405bdc8bdfaf3706dd23b419b34ec562714cca
) || false
