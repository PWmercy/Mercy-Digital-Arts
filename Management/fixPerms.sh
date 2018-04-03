### When we transitioned to Active Directory for Mac lab login accounts,
### some cleanup was required. adName assumed to same as folder name.
############################
### TEST BEFORE REUSING! ###
############################


#!/bin/bash
## cd to Digiarts-Home-folderList

folderList=`ls`

for folder in $folderList; do

  adName='STUDENT\'$folder
  echo $adName
  if [ $folder != '@eaDir' ]; then
  chown -R $adName $folder
  chmod 755 -R $folder
  chmod 700 $folder'/My-Stuff'
  chmod 733 $folder'/Public/Drop Box'
  fi

done
