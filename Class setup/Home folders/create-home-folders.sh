#!/bin/bash

# 20200929 Sync github version with CATA-NAS-HA Scripts version
# 20190828 Update for new Domain, MERCY (STUDENT no longer in use)

## Usage
## This runs on the Synology NAS (catanasha.digiarts.mercy)
## NOTE: Running from within /volume/scripts, data file location must be 
## complete path and is passed in the command
## /volume1/scripts$ sudo sh make_home_folders.sh /volume1/scripts/data_file.data

# CD to Digiarts-Home-folders
cd '/volume1/Digiarts-Home-folders'

while IFS=$'\t' read studentName
# while read MavName
# for homeFolder in `ls -d *`; do
# echo $homeFolder

do

  ADname="MERCY\\$studentName"

  # if exists folder ODname

  if [ -d $studentName ]; then
    echo "Found Home folder $studentName"
    # set owner to ADname
  else
    # else Create new home folder
    echo "$studentName not found."
    echo "creating $studentName"
    mkdir $studentName
    cd $studentName

    # Sub folders Public/Drop Box, My-Stuff
    mkdir "My-Stuff"
    mkdir -p "Public/Drop Box"
    # Set permissions
    # chown -R

    echo "Created new Home folder, set owner to $ADname and set permissions"
    echo "Done"
  fi
  # cd '/Users/pwhite/Desktop/TestPermsFix'
cd '/volume1/Digiarts-Home-folders'
  # Set owner and permissions for current folder
  chown -R $ADname:administrators $studentName
  chmod 755 $studentName
  chmod 700 $studentName/My-Stuff
  chmod 733 $studentName/Public/Drop\ Box
  #  echo $homeFolder
  #  echo  $homeFolder/My-Stuff
  #  echo  $homeFolder/Public/Drop\ Box
  echo "Set ownership of $studentName to $ADname:administrators"
  cd '/volume1/Digiarts-Home-folders'
  # cd '/Users/pwhite/Desktop/TestPermsFix'
done < $1
