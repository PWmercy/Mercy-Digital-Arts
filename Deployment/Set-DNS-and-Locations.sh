#!/bin/sh

# Commands to set and get Network settings and locations
# Also see https://gist.github.com/jjnilton/add1eeeb3a9616f53e4c

networksetup -createlocation "Digiarts DNS" populate
networksetup -switchtolocation "Digiarts DNS"

# Following line will vary depending on interfaces
# To get interfaces, use
# networksetup -listallnetworkservices
networksetup -setdnsservers "Ethernet" 172.31.48.124
networksetup -listlocations
networksetup -getcurrentlocation

# To clear DNS setting in Automatic
networksetup -switchtolocation "Automatic"
networksetup -setdnsservers "Ethernet" empty

# Finally set to Digiarts locations
networksetup -switchtolocation "Digiarts DNS"
