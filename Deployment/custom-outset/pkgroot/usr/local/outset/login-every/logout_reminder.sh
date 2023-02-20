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

dialogTitle="Don't forget to log out before you leave!"
dialogMessage="Log out **completely** before you leave"
dialogIcon="SF=display.trianglebadge.exclamationmark color1=blue color2=yellow"
dialogButton1="I won't forget."

#################
# Call dialog
#################

"$dialogPath" \
--timer 90 \
--hidetimerbar \
--blurscreen \
--icon "$dialogIcon" \
--title "$dialogTitle" \
--message "$dialogMessage" \
--button1text "$dialogButton1" \
--autoplay 3 \
--image "/usr/local/share/swiftdialogimgs/proper_login.png" \
--imagecaption "You're not done until you see this screen." \
--image "/usr/local/share/swiftdialogimgs/save.png" \
--imagecaption "Unsaved files prevent programs from quitting." \
--image "/usr/local/share/swiftdialogimgs/interrupted_logout.png" \
--imagecaption "Running programs prevent logout from completing." \
--image "/usr/local/share/swiftdialogimgs/logged-in-locked.png" \
--imagecaption "When you leave, the next user can't log in." \
--infobox "## _QUIT_ programs fully.  \n ### Save or _discard_ open files  \n ## _WAIT_ for login screen."

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