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

# disable Mission Control "Move left/right a space" so Ctrl+Left/Right reach apps (e.g. nvim window resize)
# AppleSymbolicHotKeys IDs: 79/80 = move-left (with/without Option), 81/82 = move-right
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{enabled = 0; value = { parameters = (65535, 123, 262144); type = "standard"; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 '{enabled = 0; value = { parameters = (65535, 123, 786432); type = "standard"; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 '{enabled = 0; value = { parameters = (65535, 124, 262144); type = "standard"; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 '{enabled = 0; value = { parameters = (65535, 124, 786432); type = "standard"; }; }'
# try to apply above settings, but still might need logout/reboot to take effect
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# remove default usage of osxkeychain in xcode config
# TODO: requires full disk permission for whatever term is calling or tool is editing this file
#TMP_GITCONFIG_FILE=$(mktemp)
#sudo gsed --null-data --regexp-extended 's/^\[credential\]\n. *?helper = osxkeychain *?\n//g' /Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig > $TMP_GITCONFIG_FILE
#sudo mv $TMP_GITCONFIG_FILE /Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig

# bump max open file descriptors
MAXFILES=524288

sudo tee /Library/LaunchDaemons/limit.maxfiles.plist >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key><string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>$MAXFILES</string>
      <string>$MAXFILES</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>ServiceIPC</key><false/>
  </dict>
</plist>
EOF

sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
sudo chmod 0644 /Library/LaunchDaemons/limit.maxfiles.plist

sudo launchctl unload /Library/LaunchDaemons/limit.maxfiles.plist 2>/dev/null || true
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
