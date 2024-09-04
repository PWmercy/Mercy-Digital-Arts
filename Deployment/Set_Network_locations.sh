#!/bin/sh

# Edited 20210113

# Commands to set and get Network settings and locations
# Also see https://gist.github.com/jjnilton/add1eeeb3a9616f53e4c

networksetup -createlocation "Digiarts DNS" populate
networksetup -switchtolocation "Digiarts DNS"

# setdnsservers parameter (usually "Ethernet") may vary depending on interfaces
# To get interfaces, use
# networksetup -listallnetworkservices

networksetup -setdnsservers "Ethernet" 172.31.48.124
networksetup -listlocations
networksetup -getcurrentlocation

# Create backup location - point to Main Synology
networksetup -createlocation "Digiarts DNS2" populate
networksetup -switchtolocation "Digiarts DNS2"
networksetup -setdnsservers "Ethernet" 172.31.48.200


# To clear DNS setting in Automatic to get to default
networksetup -switchtolocation "Automatic"
networksetup -setdnsservers "Ethernet" empty

# Finally set to Digiarts location
networksetup -switchtolocation "Digiarts DNS"
