#!/bin/bash

echo "Started"
directoryDomain="/LDAPv3/miniserv5.digiarts.mercy"
#	Username of a directory administrator
directoryUsername="dadmin"
#	Password for the above directory administrator
directoryPassword="x4l1t0l"
class="cart110dfa"

while	IFS=$'\t' read shortname skipme

do
	#shortname=`echo "${importFirstName:0:1}${importLastName:0:1}$importID" | tr "[:upper:]" "[:lower:]"`
	echo "$shortname with student ID $importID has been added to class $class"
	#dseditgroup -o read -u $directoryUsername -P $directoryPassword -n $directoryDomain $class
 #	echo "dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $class"
dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $class
	#	echo $importFirstName
	#	echo $importLastName
	#	echo $importID
	#	echo $importNotes

done < $1
