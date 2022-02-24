#!/bin/sh
## postinstall

# Based on script for Pro Tools 12 found on Slack #musicsupport
# The package has some post-install scripts that assume a user is logged in, let's spoof it.

# Set the following variable to the name of the Pro Tools installer package.
PTPKG="Avid_Pro_Tools_12.8.1.pkg"

# Uninstall Avid Application Manager

# Bye bye Avid Application Manager
launchctl unload -F "/Library/LaunchAgents/com.avid.avidlink.plist"
killall AvidLink
rm -rf "/Applications/Avid/Application Manager"
rm -rf "/Applications/Avid/Avid Link"
rm -rf "/Library/Application Support/Avid/AvidLink"
rm -rf "/Library/LaunchAgents/com.avid.avidlink.plist"
pkgutil --forget com.avid.installer.osx.ProToolsApplicationAppMan

# Bye bye Application Manager Uninstaller
rm -rf "/Applications/Avid_Uninstallers/Application Manager"
pkgutil --forget com.avid.ApplicationManager.Uninstaller.pkg

#!/bin/bash

# Install the Avid AIR Instruments and Plugins from their original disk images, which should be cached by the Jamf Pro policy running this script. InstallPKG is required.

# Install them!

/usr/local/bin/installpkg -ih "/Library/Application Support/JAMF/Waiting Room/Avid_First_AIR_Effects_Bundle_12.0_Mac.dmg"
/usr/local/bin/installpkg -ih "/Library/Application Support/JAMF/Waiting Room/Avid_First_AIR_Instruments_Bundle_12.0_Mac.dmg"
/usr/local/bin/installpkg -ih "/Library/Application Support/JAMF/Waiting Room/Avid_Xpand_II_12.0_Mac.dmg"

# Install the Avid Additional Value Content (some extra plugins woohoo!) which should be cached by the Jamf Pro policy running this script.
# Note that this DMG has been created by us from a folder containing the original installer packages from Avid. It does not come from them like this. InstallPKG is required.

/usr/local/bin/installpkg -ih "/Library/Application Support/JAMF/Waiting Room/Avid_Pro_Tools_Additional_Value_Content_12.1.dmg"

# Clean up

/bin/rm -rf "/Library/Application Support/JAMF/Waiting Room/Avid*"

# Set content paths for AIR Instruments

/usr/bin/defaults write /Library/Preferences/com.airmusictech.Boom Content -string "/Applications/AIR Music Technology/Boom"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Mini\ Grand Content -string "/Applications/AIR Music Technology/Mini Grand"
/usr/bin/defaults write /Library/Preferences/com.airmusictech.Xpand\!2 Content -string "/Applications/AIR Music Technology/Xpand!2"
/bin/chmod 644 /Library/Preferences/com.airmusictech.Boom.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Mini\ Grand.plist
/bin/chmod 644 /Library/Preferences/com.airmusictech.Xpand\!2.plist

# This part installs a privileged helper that would otherwise ask for admin privileges when Pro Tools is launched for the first time.

# Copy the com.avid.bsd.ShoeTool Helper Tool
PHT_SHOETOOL="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

/bin/cp -f "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoetoolv120" $PHT_SHOETOOL
/usr/sbin/chown root:wheel $PHT_SHOETOOL
bin/chmod 544 $PHT_SHOETOOL

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
