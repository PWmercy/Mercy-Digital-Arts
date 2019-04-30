#!/bin/sh
# 20160921 As of today, ExpanDrive requires license in each user Library
# Two files must be on /Users/admin/Desktop for this to work

homeFolderlist=`ls /Users`

for theUser in $homeFolderlist; do

# Check if item in /Users is a directory

if [ $theUser != "Shared" ] && [ $theUser != "Guest" ] && [ $theUser != "qubeproxy" ] && [ $theUser != "root" ] && [ $theUser != ".localized" ] && [ -d "/Users/$theUser" ] ; then
  echo "$theUser is a candidate"
      if [ -d "/Users/$theUser/Library/Application Support/ExpanDrive/branding" ]; then
      echo "ExpanDrive folder already exists"
    else
      mkdir -p "/Users/$theUser/Library/Application Support/ExpanDrive/branding"
      echo "Created /Users/$theUser/Library/Application Support/ExpanDrive/branding."
      cp /Users/admin/Desktop/configuration.js "/Users/$theUser/Library/Application Support/ExpanDrive/branding/"
      cp /Users/admin/Desktop/ExpanDrive5.ExpanDriveLicense "/Users/$theUser/Library/Application Support/ExpanDrive/"
      chmod -R 755 "/Users/$theUser/Library/Application Support/ExpanDrive"
      chown -R $theUser:staff "/Users/$theUser/Library/Application Support/ExpanDrive"
      echo "Copied and set permissions for /Users/$theUser/Library/Application Support/ExpanDrive."
    fi

fi
done
