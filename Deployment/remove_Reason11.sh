#!/bin/bash

if [[ -e "/Applications/Reason 12.app" ]]

then

if [[ -e "/Applications/Reason 11.app" ]]

then
	echo "I'll delete it"
	rm -r "/Applications/Reason 11.app"

else
	echo "nothing here"

fi

fi
