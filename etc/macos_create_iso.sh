#!/usr/bin/env bash

# https://gist.github.com/julianxhokaxhiu/286017b9872474d2c9b9fa090f6802bf

#===========================================================================
# Works only with the official image available in the Mac App Store.
# Make sure you download the official installer before running this script.
#===========================================================================

# Change this at your desire. Sometimes this works out of the box, sometimes not.
# Default size: ~13.5 GB
DISK_SIZE="13000m"

#===========================================================================

hdiutil create -o /tmp/macos.cdr -size $DISK_SIZE -layout SPUD -fs HFS+J
hdiutil attach /tmp/macos.cdr.dmg -noverify -mountpoint /Volumes/install_build
sudo /Applications/Install\ macOS\ *.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build --nointeraction
hdiutil detach "/Volumes/Shared Support 1"
hdiutil detach "/Volumes/Shared Support"
hdiutil detach /Volumes/Install\ macOS\ *
hdiutil convert /tmp/macos.cdr.dmg -format UDTO -o /tmp/macos.iso
mv /tmp/macos.iso.cdr ~/Desktop/macos.iso
rm /tmp/macos.cdr.dmg

