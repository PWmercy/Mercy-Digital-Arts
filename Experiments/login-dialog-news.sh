#!/bin/sh

# Let's try to give a reminder on login to log out!
# We'll use "(Swift) dialog"

#Define dialog path for convenience
dialogPath=/usr/local/bin/dialog

#Create a tmp file to hold our dialog options
# tmpDialogFile1=$(mktemp /tmp/tmpDialogFile1.XXXXXX)

#################
# Set the options we'll use for the dialog window
#################

dialogTitle="Important News!"
dialogMessage="\n## Tuesday, Mar 14 ## \n ### is the LAST day for course withdrawal. ###"
dialogIcon="SF=display.trianglebadge.exclamationmark color1=blue color2=yellow"
dialogButton1="Got it."

#################
# Call dialog
#################

"$dialogPath" \
-s \
--hideicon \
--messagealignment center \
--timer 90 \
--hidetimerbar \
--ontop \
--message "$dialogMessage" \
--button1text "$dialogButton1" \

# ########################
# Following from original source. Not currently in use.
# ########################

# Capture the exit code of the previous dialog command. This informs us of 
# what the user did.
# dialogResult=$?

# "$dialogPath" --title "Thank you for doing your part!" \
# --message  ""
# --icon "$dialogIcon" \
# --centericon \
# --alignment center