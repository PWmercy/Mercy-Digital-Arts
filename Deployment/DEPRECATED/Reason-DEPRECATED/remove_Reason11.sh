#!/bin/bash

if [[ -e "/Applications/Reason 12.app" ]]
then

if [[ -e "/Applications/Reason 11.app" ]]
then
	rm -r "/Applications/Reason 11.app"
    echo "Reason 11 removed"

else
	echo "nothing here"

fi

fi
