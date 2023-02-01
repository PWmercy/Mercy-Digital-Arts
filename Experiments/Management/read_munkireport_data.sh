#!/bin/bash

# POST-INSTALL script for imagr
# This script reads from a data file, created from Munki Report ARD report page
# It is used to replace the ARD fields and Computer name after a wipe or new OS install

# The file must be in Tab-delimited format
# Sample Data (6 columns):
# C07J90G6F4MH<TAB>	vh208mc12237mac04<TAB>	MC12237<TAB>	Victory-208-04<TAB>  <TAB>		9/2012 CART

# Get local machine Serial

thisSerialNum=`/usr/sbin/system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $NF}'`

#  "Ser read is $thisSerialNum"

# Set ARD Kickstarter path

ksDir="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources"

# Download data file from imagr server

curl -k http://munki6.digiarts.mercy:8090/webdocs/20210125_MunkiReport.data > /tmp/munkireport.data

# Set local copy as input

_input="/tmp/munkireport.data"

# _input="/Users/pwhite/Desktop/20210125_MunkiReport.data"

# IFS=$'\t' sets delimiter as TAB

while	IFS=$'\t' read -r serNum compName field1 field2 field3 field4
do
    # echo $compName
    if [ "$serNum" = "$thisSerialNum" ]
    then
        echo $serNum
        echo $compName
        echo $field1
        echo $field2
        echo $field3
        echo $field4

        # Restore ARD fields
        $ksDir/kickstart -configure -computerinfo -set1 -1 "$field1"
        $ksDir/kickstart -configure -computerinfo -set2 -2 "$field2"
        $ksDir/kickstart -configure -computerinfo -set3 -3 "$field3"
        $ksDir/kickstart -configure -computerinfo -set4 -4 "$field4"

        # Restore computer name and host names
        # /usr/sbin/scutil --set HostName $compName
        # /usr/sbin/scutil --set LocalHostName $compName
        # /usr/sbin/scutil --set ComputerName $compName
        #
        # /usr/bin/dscacheutil -flushcache

        # Once found, leave the read While loop
        break
    else
        echo "not found"
    fi

done < $_input
