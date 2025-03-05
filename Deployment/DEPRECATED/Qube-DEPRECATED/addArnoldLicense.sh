#!/bin/sh

# if [ -e "/Users/qubeproxy/.flexlmrc" ]; then
#   echo "It's there"
# else
#   echo "Creating file"
#   touch  "/Users/qubeproxy/.flexlmrc"
# fi
# echo "Testing 4 5 6" >> "/Users/qubeproxy/.flexlmrc"

# ###### Following is work in progress for Outset login-once ######
# 1) Test if /Users/$USER/.flexlmrc exists
# 2) If so, see if it contains line
# "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy"
# then append it if necessary
# 3) If not, create file /Users/$USER/.flexlmrc
#  #### CODE ####

if [ -e "/Users/$USER/.flexlmrc" ]; then
  #  echo "It's there"
  
  if grep -Fxq "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" "/Users/$USER/.flexlmrc"
  then : # do nothing
  else
    echo "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" >> "/Users/$USER/.flexlmrc"
  fi
else
  #  echo "Creating file"
  touch  "/Users/$USER/.flexlmrc"
  echo "ADSKFLEX_LICENSE_FILE=@miniserv2.digiarts.mercy" >> "/Users/$USER/.flexlmrc"
fi
