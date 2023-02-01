#!/bin/bash


# In Fall 2016, worked with IT to add Macs to AD.
#
# Part of this process involved changing our existing machine names, e.g., "Victory-200-01"
# to a form compatible with their 15 character limit, e.g., vh200mc99999mac01, where the 2 digits at the end are ignored
#
# In order to correctly sort in ARD, this script puts a name in the old format in Computer Info field 2
# For now, script relies on new format and exact length so will not work with "inst"

# kickstart parameters from http://ss64.com/osx/kickstart.html

	# get current machine name, e.g., vh200mc99999mac01.local
	sharename=$(scutil --get ComputerName)
	# grab room number from new format name
	start="Victory-"${sharename:2:3}
	# grab last 2 digits
	end="-"${sharename:15:2}
	fullname=$start$end
	# echo $fullname
	# ARD kickstart to set Field 2
	"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set2 -2 $fullname"
