#!/bin/bash

echo "Started"
directoryDomain="/LDAPv3/miniserv5.digiarts.mercy"
#	Username of a directory administrator
directoryUsername="dadmin"
#	Password for the above directory administrator
directoryPassword="x4l1t0l"

while	read shortname importID

do
if [ $shortname == "class" ]
	then
	className=$importID #First line is actually class name
	else
	#shortname=`echo "${importFirstName:0:1}${importLastName:0:1}$importID" | tr "[:upper:]" "[:lower:]"`
	echo "$shortname with student ID $importID is in class $className"
	dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $className
	#	echo $importFirstName
	#	echo $importLastName
	#	echo $importID
	#	echo $importNotes
fi

done < $1
