#!/bin/bash

sleep 30
# Script to find current bind information
adDomain="$(dsconfigad -show | awk '{if(NR==2) print $5}')"
adDomainOnly="$(echo $adDomain | sed 's/\..[^.]*\.*.*/ /g' | sed 's/[[:space:]]//g' | tr '[:lower:]' '[:upper:]')"
adComputerAccount="$(dsconfigad -show | awk '{if(NR==3) print $4}')"
adComputerName="$(echo $adComputerAccount | sed 's/\$//g')"
checkou () {
if [ "$adDomain" == "" ]; then echo "Not bound."; exit; fi
for i in $(dscl /Active\ Directory/$adDomainOnly/All\ Domains -list /Computers); do
distName=$(dscl /Active\ Directory/$adDomainOnly/All\ Domains -read /Computers/$i distinguishedName | awk '{ print $2 }')
echo "DN:" $distName | grep "$adComputerName"
echo ""
done
}
if [ "$(checkou)" == "" ]; then
echo "Stale Bind."
else
checkou
echo ""
echo "dsconfigad: "
dsconfigad -show
fi
