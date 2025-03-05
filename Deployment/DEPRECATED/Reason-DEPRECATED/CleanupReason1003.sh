#!/bin/sh

###################################################################################
################################## DEPRECATED #####################################
###################################################################################

#################################################
### Reason 10.3 update doesn't seem to move the Orkester and Factory refills into
### Application Support as with previous first-runs.
### This script does some cleanup by moving Orkester to
### /Library/Application Support/Propellerhead Software/Soundbanks/Orkester/
### and Factory Sound Bank into
### /Library/Application Support/Propellerhead Software/Soundbanks/Reason 10/,
### replacing older versions.
###
### We also delete old Reason 9 folder from Soundbanks
#################################################

ReasonAppPath="/Applications/Reason 10"
ReasonSoundbankPath="/Library/Application Support/Propellerhead Software/Soundbanks"

echo "moving $ReasonAppPath/Orkester.rfl to $ReasonSoundbankPath/Orkester/"
mv "$ReasonAppPath/Orkester.rfl" "$ReasonSoundbankPath/Orkester/"
mv "$ReasonAppPath/Factory Sound Bank.rfl" "$ReasonSoundbankPath/Reason 10/"
rm -R "$ReasonSoundbankPath/Reason 9/"
