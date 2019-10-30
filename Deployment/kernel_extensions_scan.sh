#!/bin/bash
# Downloaded from https://mybusiness.mosyle.com/downloads/scripts/kernel_extensions.sh
# Script to scan a system for kexts and gather the information needed for Apple whitelisting
# Stop IFS linesplitting on spaces
OIFS=$IFS
IFS=$'\n'
# Scan the following folders to find 3rd party kexts
# /Applications
# /Library/Extensions
# /Library/Application Support
echo "Searching Applications folder"
applic=($( find /Applications -name "*.kext" ))
echo "Searching Library Extensions folder"
libext=($( find /Library/Extensions -name "*.kext" -maxdepth 1 ))
echo "Searching Library Application Support folder"
libapp=($( find /Library/Application\ Support -name "*.kext" ))
echo ""
# Merge the arrays together
results=("${applic[@]}" "${libext[@]}" "${libapp[@]}")
if [ ${#results[@]} != "0" ];
then
    for (( loop=0; loop<${#results[@]}; loop++ ))
    do
        # Get the Team Identifier for the kext
        teamid=$( codesign -d -vvvv ${results[$loop]} 2>&1 | grep "Authority=Developer ID Application:" | cut -d"(" -f2 | tr -d ")" )
        # Get the CFBundleIdentifier for the kext
        bundid=$( defaults read "${results[$loop]}"/Contents/Info.plist CFBundleIdentifier )
        echo "Team ID: $teamid  Bundle ID: $bundid"
    done
fi
IFS=$OIFS
exit
