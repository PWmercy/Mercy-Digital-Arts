#!/bin/sh

# 20190502

# ###### Following is work in progress for Outset login-once ######

# 1) Test if /Users/$USER/.flexlmrc exists
# 2) If so, see if it contains line
# "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy"
# then append it if missing
# 3) If not, create file /Users/$USER/.flexlmrc and append

#### CODE ####

if [ -e "/Users/$USER/.flexlmrc" ]; then
    #  echo "It's there"

    if ! grep -Fxq "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" "/Users/$USER/.flexlmrc"; then
        echo "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" >> "/Users/$USER/.flexlmrc"
    fi

else
    #  echo "Creating file"
    touch  "/Users/$USER/.flexlmrc"
    echo "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" >> "/Users/$USER/.flexlmrc"
fi
