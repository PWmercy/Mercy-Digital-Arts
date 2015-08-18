#!/bin/bash

echo "Started"
directoryDomain="/LDAPv3/miniserv5.digiarts.mercy"
#	Username of a directory administrator
directoryUsername="$2"
#	Password for the above directory administrator
directoryPassword="$3"

while	read shortname importID

do
if [ $shortname == "class" ]
	then #First line is actually class name, e.g. CART123MTA
	className=$importID
	else
	#shortname=`echo "${importFirstName:0:1}${importLastName:0:1}$importID" | tr "[:upper:]" "[:lower:]"`
	echo "$shortname with student ID $importID has been added to class $className"
	dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $className
	#	echo $importFirstName
	#	echo $importLastName
	#	echo $importID
	#	echo $importNotes
fi

done < $1
