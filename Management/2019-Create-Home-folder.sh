#!/bin/bash

# 20190809 Update for new Domain, MERCY (STUDENT no longer in use)

# CD to Digiarts-Home-folders
cd '/volume1/Digiarts-Home-folders' || exit

# while	IFS=$'\t' read MavName
# while read MavName
for homeFolder in $(ls -d *); do
    echo $homeFolder
    ADname="MERCY\\$homeFolder"

    # do
    #
    #
    #   # if exists folder ODname
    #
    #   if [ -d $MavName ]; then
    #     echo "Found Home folder $MavName"
    #     # set owner to ADname
    #   else
    #     # else Create new home folder
    #     echo "Out of if "
    #     echo "creating $MavName"
    #     mkdir $MavName
    #     cd $MavName
    #
    #     # Sub folders Public/Drop Box, My-Stuff
    #     mkdir "My-Stuff"
    #     mkdir -p "Public/Drop Box"
    #     # Set permissions
    #     # chown -R
    #
    #     echo "Created new Home folder, set owner to $ADname and set permissions"
    #     echo "Done"
    #   fi
    #   cd '/Users/pwhite/Desktop/TestPermsFix'
    #
    #   # Set owner and permissions for current folder
    #   chown -R $ADname:staff $MavName
    #   chmod 755 $MavName
    #   chmod 700 $MavName/My-Stuff
    #   chmod 733 $MavName/Public/Drop\ Box
    echo $MavName
    echo  $MavName/My-Stuff
    echo  $MavName/Public/Drop\ Box

    #  cd '/volume1/Digiarts-Home-folders'
    cd '/Users/pwhite/Desktop/TestPermsFix'
done
# done < $1
