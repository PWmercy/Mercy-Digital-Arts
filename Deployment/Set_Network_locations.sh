#!/bin/sh

# Edited 202412

# Commands to set and get Network settings and locations
# Also see https://gist.github.com/jjnilton/add1eeeb3a9616f53e4c

networksetup -listlocations
networksetup -getcurrentlocation


# Get list of nameservers for current location:
# scutil --dns

networksetup -createlocation "Digiarts DNS" populate
networksetup -switchtolocation "Digiarts DNS"
networksetup -setdnsservers "Ethernet" 172.31.48.124

# Get list of nameservers for current location:
scutil --dns

# setdnsservers parameter (usually "Ethernet") may vary depending on interfaces
# To get interfaces, use
networksetup -listallnetworkservices

networksetup -listlocations
networksetup -getcurrentlocation

# To empty current location:
sudo networksetup -setdnsservers "Ethernet" "Empty"

# Create backup location - point to Main Synology

networksetup -createlocation "Digiarts DNS2" populate
networksetup -switchtolocation "Digiarts DNS2"
networksetup -setdnsservers "Ethernet" 172.31.48.200

# To clear DNS setting in Automatic to get to default
networksetup -switchtolocation "Automatic"
networksetup -setdnsservers "Ethernet" empty

# Finally set to Digiarts location
networksetup -switchtolocation "Digiarts DNS"
