#!/usr/bin/env bash

# compact status bar icons to fit more and avoid notch hiding issue
# values are half of typical baseline (12, 8); delete keys entirely to restore macOS default feel
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 6
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 4

curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz |
	tar zxvf - -C "$HOME"/Library/Fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz |
	tar zxvf - -C "$HOME"/Library/Fonts

# for vscodevim key repeat
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# remove default usage of osxkeychain in xcode config
# TODO: requires full disk permission for whatever term is calling or tool is editing this file
#TMP_GITCONFIG_FILE=$(mktemp)
#sudo gsed --null-data --regexp-extended 's/^\[credential\]\n. *?helper = osxkeychain *?\n//g' /Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig > $TMP_GITCONFIG_FILE
#sudo mv $TMP_GITCONFIG_FILE /Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig
