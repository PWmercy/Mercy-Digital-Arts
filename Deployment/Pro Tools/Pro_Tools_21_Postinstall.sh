#!/bin/sh
## postinstall

# EDITS 202202 by pwhite@mercy.edu
# Some items were renamed and fall under Avid Link
# Purpose: 1) Avoid requirement for admin password when helper tool installs.
#          2) Remove avid link and avid cloud

# Based on script for Pro Tools 12 found on Slack #musicsupport

# Uninstall Avid Application Manager

# Bye bye Avid Application Manager
rm -rf "/Applications/Avid/Application Manager/AvidApplicationManager.app"
launchctl unload -F "/Library/LaunchAgents/com.avidlink.plist"
launchctl unload -F "/Library/LaunchAgents/com.avid.CloudClientServices.plist"
launchctl unload -F "/Library/LaunchAgents/com.avid.ApplicationManager.plist"

killall AvidLink
rm -rf "/Applications/Avid/Avid Link"
rm -rf "/Applications/Avid/Application Manager"
rm -rf "/Library/Application Support/Avid/AvidLink"
rm -rf "/Library/LaunchAgents/com.avid.ApplicationManager.plist"
rm -rf "/Library/LaunchAgents/com.avid.avidlink.plist"
rm -rf "/Library/LaunchAgents/com.avid.CloudClientServices.plist"
rm -rf "/Library/Application Support/Avid/Cloud Client Services"
rm -rf "/Library/LaunchAgents/com.avid.transport.client.plist"

pkgutil --forget com.avid.installer.osx.ProToolsApplicationAppMan
pkgutil --forget com.avid.cloudservices.pkg
pkgutil --forget com.avid.AvidLink.component.pkg

	# Bye bye Application Manager Uninstaller
	rm -rf "/Applications/Avid_Uninstallers/Avid Link/Avid Link Uninstaller.app"
	rm -rf "/Applications/Avid_Uninstallers/Cloud Client Services Uninstaller.app"
	rm -rf "/Applications/Avid_Uninstallers"
	pkgutil --forget com.avid.AvidLink.uninstaller.pkg
	pkgutil --forget com.avid.CloudClientServicesUninstaller

#!/bin/bash

# Set content paths for AIR Instruments

/usr/bin/defaults write /Library/Preferences/com.airmusictech.Boom Content -string "/Applications/AIR Music Technology/Boom"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Mini\ Grand Content -string "/Applications/AIR Music Technology/Mini Grand"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Xpand\!2 Content -string "/Applications/AIR Music Technology/Xpand!2"
/bin/chmod 644 /Library/Preferences/com.airmusictech.Boom.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Mini\ Grand.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Xpand\!2.plist

######
## This part installs a privileged helper that would otherwise ask for
## admin privileges when Pro Tools is launched for the first time.
######

# Copy the com.avid.bsd.ShoeTool Helper Tool
PHT_SHOETOOL="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

/bin/cp -f "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoetoolv120" $PHT_SHOETOOL
/usr/sbin/chown root:wheel $PHT_SHOETOOL
bin/chmod 544 $PHT_SHOETOOL

# Create the Launch Daemon Plist for com.avid.bsd.ShoeTool
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

mkdir "/Users/Shared/Pro Tools"
mkdir "/Users/Shared/AvidVideoEngine"

chown -R root:wheel /Users/Shared/Pro\ Tools
chmod -R a+rw /Users/Shared/Pro\ Tools
chown -R root:wheel /Users/Shared/AvidVideoEngine
chmod -R a+rw /Users/Shared/AvidVideoEngine

# Get rid of old workspace
rm -rf /Users/Shared/Pro\ Tools/Workspace.wksp

# Done.

exit 0
