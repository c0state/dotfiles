mas signin --dialog

mas install 497799835 # xcode

# set xcode tools to full version; see: https://stackoverflow.com/a/17980786
echo "Setting full version of XCode tools"
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

echo "Accepting XCode license"
sudo xcodebuild -license accept

mas install 1356178125 # jigsaw outline client
