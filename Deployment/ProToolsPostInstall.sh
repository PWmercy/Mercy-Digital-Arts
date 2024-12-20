#!/bin/sh

# From neilmartin83, Found on Slack

# Bye bye Avid Application Manager
launchctl unload -F "/Library/LaunchAgents/com.avid.ApplicationManager.plist"
killall AvidApplicationManager
killall AvidAppManHelper
rm -rf "/Applications/Avid/Application Manager"
rm -rf "/Library/Application Support/Avid/AppManager"
rm -rf "/Library/LaunchAgents/com.avid.ApplicationManager.plist"
pkgutil --forget com.avid.AppManagerHelpercomponent.pkg
pkgutil --forget com.avid.AppManagercomponent.pkg

# Bye bye Application Manager Uninstaller
rm -rf "/Applications/Avid_Uninstallers/Application Manager"
pkgutil --forget com.avid.ApplicationManager.Uninstaller.pkg

# Set content paths for AIR Instruments

/usr/bin/defaults write /Library/Preferences/com.airmusictech.Boom Content -string "/Applications/AIR Music Technology/Boom"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Mini\ Grand Content -string "/Applications/AIR Music Technology/Mini Grand"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Xpand\!2 Content -string "/Applications/AIR Music Technology/Xpand!2"
/bin/chmod 644 /Library/Preferences/com.airmusictech.Boom.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Mini\ Grand.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Xpand\!2.plist

# This part installs a privileged helper that would otherwise ask for admin privileges when Pro Tools is launched for the first time.
# It checks that Pro Tools has already been installed and will not run if it hasn't.

# Copy the com.avid.bsd.ShoeTool Helper Tool
PHT_SHOETOOL="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

/bin/cp -f "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoetoolv120" $PHT_SHOETOOL
/usr/sbin/chown root:wheel $PHT_SHOETOOL
/bin/chmod 544 $PHT_SHOETOOL

# Create the Launch Deamon Plist for com.avid.bsd.ShoeTool
PLIST="/Library/LaunchDaemons/com.avid.bsd.shoetoolv120.plist"
FULL_PATH="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

rm $PLIST # Make sure we are idempotent

/usr/libexec/PlistBuddy -c "Add Label string" $PLIST
/usr/libexec/PlistBuddy -c "Set Label com.avid.bsd.shoetoolv120" $PLIST

/usr/libexec/PlistBuddy -c "Add MachServices dict" $PLIST
/usr/libexec/PlistBuddy -c "Add MachServices:com.avid.bsd.shoetoolv120 bool" $PLIST
/usr/libexec/PlistBuddy -c "Set MachServices:com.avid.bsd.shoetoolv120 true" $PLIST

/usr/libexec/PlistBuddy -c "Add ProgramArguments array" $PLIST
/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" $PLIST
/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 $FULL_PATH" $PLIST

/bin/launchctl load $PLIST

mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins"
mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins (Unused)"

chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins"
chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins (Unused)"

mkdir /Users/Shared/Pro\ Tools
mkdir /Users/Shared/AvidVideoEngine

chown -R root:wheel /Users/Shared/Pro\ Tools
chmod -R a+rw /Users/Shared/Pro\ Tools
chown -R root:wheel /Users/Shared/AvidVideoEngine
chmod -R a+rw /Users/Shared/AvidVideoEngine

# Get rid of old workspace
rm -rf /Users/Shared/Pro\ Tools/Workspace.wksp

# Done.

exit 0
