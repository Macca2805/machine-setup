# Pull down launch agent file
mkdir -p ~/Library/LaunchAgents
rm -rf ~/Library/LaunchAgents/com.user.machine-setup.plist
curl https://raw.githubusercontent.com/Macca2805/machine-setup/main/com.user.machine-setup.plist > ~/Library/LaunchAgents/com.user.machine-setup.plist

# Load script via launchctl to launch script on login
launchctl load ~/Library/LaunchAgents/com.user.machine-setup.plist