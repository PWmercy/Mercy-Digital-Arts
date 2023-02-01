#!/bin/bash
# This script will mount smb share for logged user.
sleep 2.5
# The logs
LOG_FILE="/var/tmp/mountsmbshare.log"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
echo "$(DATE)"
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'ENCAP'
if [ "$USER" == root ]; then echo "Root user detected! Unable to mount SMB shares."; exit 1; fi
mountsmb () {
SMBINFO="$1"
CREDENTIALS="$2"
SHARENAME="$(basename $SMBINFO)"
mount_t=$(/usr/bin/osascript > /dev/null << EOT
on getShares()
	tell application "System Events" to get the name of every disk
end getShares
tell application "Finder"
	if not (disk "${SHARENAME}" exists) then
	set n to 0
	repeat while my getShares() does not contain "${SHARENAME}"
	set n to n + 1
		if n = 2 then
			log "Couldn't mount ${SMBINFO}"
			exit repeat
		end if
	delay 1
	log "Attempting to mount SMB Share Try Number: " & n & "."
	try
    	mount volume "smb://${CREDENTIALS}@${SMBINFO}"
    	log "${SMBINFO} mounted successfully -> /Volumes/${SHARENAME}"
	end try
	end repeat
	else
		log "${SMBINFO} is already mounted -> /Volumes/${SHARENAME}"
	end if
	end tell
EOT)
}
# usage: mountsmb "IP_OR_HOSTNAME/Share" "username:password"
# To authenticate using local user keychain: mountsmb "IP_OR_HOSTNAME/Share" "$USER"
# User specific shares can also be mounted: mountsmb "IP_OR_HOSTNAME/Home/$USER" "$USER"
mountsmb "catanas1.digiarts.mercy/Digiarts-Home-folders" "$USER"
mountsmb "catanas1.digiarts.mercy/MTEC-Class-folders" "$USER"
