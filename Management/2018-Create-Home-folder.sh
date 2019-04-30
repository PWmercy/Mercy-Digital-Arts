#!/bin/bash

# 20180829
# With all students using AD to log in to lab Macs, must change permissions and rename existing OD Home folders and
# create folders for new, AD-only accounts

# CD to Digiarts-Home-folders
cd '/Users/pwhite/Desktop/TestPermsFix'

#while	IFS=$'\t' read MavName
while read MavName

do
  ADname="STUDENT\\$MavName"

  # if exists folder ODname

  if [ -d $MavName ]; then
    echo "Found Home folder $MavName"
    # set owner to ADname
  else
    # else Create new home folder
    echo "Out of if "
    echo "creating $MavName"
    mkdir $MavName
    cd $MavName
    mkdir "My-Stuff"
    # Sub folders Public/Drop Box, My-Stuff
    mkdir -p "Public/Drop Box"
    # Set permissions
    # chown -R

    echo "Created new Home folder, set owner to $ADname and set permissions"
    echo "Done"
  fi
  cd '/Users/pwhite/Desktop/TestPermsFix'

  # Set owner and permissions for current folder
  chown -R $ADname:staff $MavName
  chmod 755 $MavName
  chmod 700 $MavName/My-Stuff
  chmod 733 $MavName/Public/Drop\ Box
  #cd '/Users/pwhite/Desktop/TestPermsFix'

done < $1
