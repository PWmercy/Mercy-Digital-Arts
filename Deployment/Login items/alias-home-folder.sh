#!/bin/sh

# sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'

aliasName="$USER My-Stuff Network Folder"

if [ ! -e "/Users/$USER/Desktop/$aliasName" ]; then

osascript -e 'set theUser to do shell script "whoami"' \
-e 'set thePath to "Volumes:Digiarts-Home-folders:" & theUser & ":My-Stuff"' \
-e 'set thePath2 to "Macintosh HD:Users:" & theUser & ":Desktop"' \
-e 'tell application "Finder" to make alias file to alias thePath at thePath2'

mv "/Users/$USER/Desktop/My-Stuff" "/Users/$USER/Desktop/$aliasName"


fi