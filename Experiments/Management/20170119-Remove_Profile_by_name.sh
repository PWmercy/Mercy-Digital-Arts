#!/bin/bash

## USAGE ##
## Append profile name to end of call
############
# sudo sh 20170119-Remove_Profile_by_name "Falcon Security (v 8)""
###########

## Get UUID of requested MDM Profile
MDMUUID=$(profiles -Lv | grep "name: $4" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}')

## Remove said profile, identified by UUID
if [[ $MDMUUID ]]; then
  echo "removing"
   profiles -R -p "$MDMUUID"
else
    echo "No Profile Found"
fi

sleep 5
