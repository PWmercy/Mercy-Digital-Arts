instllation of replacement
​
# Unload all LaunchAgents
find /Library/LaunchAgents -iname '*wacom*.plist' -maxdepth 1 -exec launchctl unload {} \;
find /Library/LaunchAgents -iname '*wacom*.plist' -maxdepth 1 -exec rm -rf {} \;
​
# Unload all LaunchDaemons
find /Library/LaunchDaemons -iname '*wacom*.plist' -maxdepth 1 -exec launchctl unload {} \;
find /Library/LaunchDaemons -iname '*wacom*.plist' -maxdepth 1 -exec rm -rf {} \;
​
# Kill any remaining processes from running
ps -ef | grep wacom | grep -v grep | grep -v installer | grep -v postinstall | awk '{print $2}' | xargs kill -9
​
# Remove all com.wacom directories from /Library/PrivilegedHelperTools
find /Library/PrivilegedHelperTools -iname '*wacom*.app' -maxdepth 1 -exec rm -rf {} \;
​
# Remove folders
find /Library/Frameworks -iname '*Wacom*.framework' -maxdepth 1 -exec rm -rf {} \;
find /Applications -iname '*Wacom*' -maxdepth 1 -exec rm -rf {} \;
find /Library/PreferencePanes -iname '*Wacom*.prefpane' -maxdepth 1 -exec rm -rf {} \;
​
rm -rf "/Library/Application Support/Tablet"/
rm -rf "/Library/Preferences/Tablet"/
​
exit
