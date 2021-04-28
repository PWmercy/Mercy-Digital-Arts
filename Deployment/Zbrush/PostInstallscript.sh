# from https://garrettyamada.com/installing-zbrush-with-munki/

# We elected to re-package ZBrush's .app along with the two necessary license files for our floating license and create a post-install script that looks like this:


## Zbrush unattended install

## "/Applications/ZBrush 2018 Installer OSX FL.app/Contents/MacOS/osx-intel" --mode unattended


#!/bin/sh

# Installer name

INSTALLER_NAME="ZBrush_2018_FL_Installer.app"

# Application folder name

APP_FOLDER_NAME="ZBrushOSX 2018 FL"


'/Applications/ZBrush_2018_FL_Installer.app/Contents/MacOS/osx-intel' --mode unattended

rm -r '/Applications/ZBrush_2018_FL_Installer.app'

mv '/Users/Shared/floating.lib' '/Applications/ZBrushOSX 2018 FL/ZData/ZPlugs64/RLM'

mv '/Users/Shared/licensefile.lic' '/Applications/ZBrushOSX 2018 FL/Licenses'

chmod 755 '/Applications/ZBrushOSX 2018 FL/ZData/ZPlugs64/RLM/floating.lib'

chmod 755 '/Applications/ZBrushOSX 2018 FL/Licenses/licensefile.lic'

exit
