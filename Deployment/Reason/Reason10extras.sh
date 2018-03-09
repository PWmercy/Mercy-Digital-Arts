#!/bin/sh

#################################################
### Reason 10 added extra instruments and refills that by default download into User Library,
### At first-run for each user, a download is requested and files are put
### into /Users/$USER/Library/Application Support/Propellerhead Software/Propellerhead Content
### Since this seems to be the only place that Reason will find it, we first move the folder
### to "/Library/Application Support/Propellerhead Software/Propellerhead Content/"
### (This is assumed to have been done before running this script)
### Then this script makes a symbolic link in the current User library in Reason's expected location (~/Library/ -->> /Library/)
### Using outset (https://github.com/chilcote/outset/wiki) and its login-once folder, this should run once for each user.
#################################################

# Check if Propellerhead Content has been moved to central folder
if [ -d "/Library/Application Support/Propellerhead Software/Propellerhead Content" ]
then
  # echo "FOUND IT!"
  # First remove folder if it exists in User Library
  if [ -d "/Users/$USER/Music/Propellerhead Content" ]
  then
    rm -R "/Users/$USER/Music/Propellerhead Content"
  fi
  # Then create symbolic link to central Library folder in local Music folder
  ln -s  "/Library/Application Support/Propellerhead Software/Propellerhead Content" "/Users/$USER/Music/Propellerhead Content"
  # chown root:admin for /Library/Application Support folder
  #chown -R root:admin "/Library/Application Support/Propellerhead Software/Propellerhead Content"
  #chmod -R go+rx "/Library/Application Support/Propellerhead Software/Propellerhead Content"
fi
