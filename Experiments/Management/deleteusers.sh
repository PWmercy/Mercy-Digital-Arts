#!/bin/sh


# https://www.jamf.com/jamf-nation/discussions/4502/remove-old-mobile-accounts#responseChild21985
#
# Description below from above link
#
# Script builds a list of users with UniqueID's higher than 1000
# (this way it's only looking at cached AD users). It then checks for home directories older than
# [mtime] days and then removes the account and home directory for that user. It also only deletes users
# who are members of our students group in AD. [Experimentation found students group is lower case "student\domain users"]

userList=`dscl . list /Users UniqueID | awk '$2 > 1000 {print $1}'`

echo "Deleting account and home directory for the following users..."


for a in $userList ; do
    if [[ "$(id $a | tr '[:upper:]' '[:lower:]')" =~ "student\domain users" ]]; then
      # "-mtime in following line is number of days old"
        find /Users -type d -maxdepth 1 -mindepth 1 -not -name "*.*" -mtime +120 | grep "$a"
        if [[ $? == 0 ]]; then
            dscl . delete /Users/"$a"  #delete the account
            rm -r /Users/"$a"  #delete the home directory
        fi
    fi
done
