#!/bin/bash
# v. 20160121.01
# This script receives a TAB-DELIMITED data file of User shortnames and class group names (e.g., jdoe <TAB> CART123DFA)
# Each line adds a user to the OD group that exists for the class (e.g., CART123DFA)
# EXAMPLE submit:
# sh path/to/nameofthisScript.sh dataFile.data

echo "Started"

directoryDomain="/LDAPv3/miniserv5.digiarts.mercy"
# If running on Server, use:
# directoryDomain="/LDAPv3/127.0.0.1"

read -p "Directory Admin name: " directoryUsername
echo $directoryUsername

#	Username of a directory administrator
# directoryUsername="dadmin"
#	Password for the above directory administrator
# directoryPassword="Password"

read -s -p "Password: " directoryPassword
# echo $directoryPassword
#
currentclass=""
# IFS=$'\t' sets delimiter as TAB
while	IFS=$'\t' read shortname class
do
#  Following if statement is redundant now that each line of format includes class
# 	if [ "$class" != "$currentclass" ]
# 		then
# 		 currentclass=$class
# 	fi

# shortname=`echo "${importFirstName:0:1}${importLastName:0:1}$importID" | tr "[:upper:]" "[:lower:]"`
# dseditgroup -o read -u $directoryUsername -P $directoryPassword -n $directoryDomain $class
#	echo "dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $class"
dseditgroup -o edit -u $directoryUsername -P $directoryPassword -n $directoryDomain -a $shortname -t user $class
echo "$shortname has been added to class $class"

	#	echo $importFirstName
	#	echo $importLastName
	#	echo $importID
	#	echo $importNotes

done < $1
