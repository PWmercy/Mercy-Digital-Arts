#!/bin/bash

# 20211004

# Create friendly computer name from Computer Name
# Assumes format vh999mc99999mac99

name=$(scutil --get ComputerName)
asset_id=${name:5:7}
room=${name:2:3}
uc_asset_id=$(echo "$asset_id" | tr '[:lower:]' '[:upper:]')
friendly_name="Victory-$room-${name:(-2)}"

echo "$name"
echo "$friendly_name"
echo "$uc_asset_id"

# Uncomment below to set ARD fields
# Field 1 is used for Asset Tag
# /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 $uc_asset_id

# Field 2 is used for friendly computer name
# /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set2 -2 $friendly_name
