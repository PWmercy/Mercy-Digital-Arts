#!/bin/bash

echo "Started"

directoryDomain="/LDAPv3/miniserv5.digiarts.mercy"
# if running on Server use:
# directoryDomain="/LDAPv3/127.0.0.1"

read -p "Directory Admin name: " directoryUsername
echo $directoryUsername

#	Username of a directory administrator
# directoryUsername="dadmin"
#	Password for the above directory administrator
# directoryPassword="x4l1t0l"

read -s -p "Password: " directoryPassword
echo $directoryPassword

currentclass=""

while	IFS=$'\t' read shortname class
do

	if [ "$class" != "$currentclass" ]
		then
		 currentclass=$class
	 fi

	#shortname=`echo "${importFirstName:0:1}${importLastName:0:1}$importID" | tr "[:upper:]" "[:lower:]"`
	echo "$shortname with student ID $importID has been added to class $currentclass"
	#dseditgroup -o read -u $directoryUsername -P $directoryPassword -n $directoryDomain $class
 #	echo "dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $class"
# dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $currentclass
	#	echo $importFirstName
	#	echo $importLastName
	#	echo $importID
	#	echo $importNotes

done < $1
