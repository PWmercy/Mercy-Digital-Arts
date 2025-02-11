#!/bin/sh

# Install or update Apple packages for Logic and Garageband (and MainStage if installed)

# NOTE this originally used AppleLoops, which was superceded by loopdown (https://github.com/carlashley/loopdown)

# Assumes install and location of loopdown and managed_python https://github.com/macadmins/python
# Assumes location of content on http server. As of 05/2024, content is on miniserv6, using MDS to run Apache

## Use macadmin python
## for details, run
##
## /usr/local/bin/managed_python3 /usr/local/bin/loopdown/loopdown -h
##
## -a = app, -i = install, -m = mandatory -o = optional -n =dry run (no downloads)

################################################
##### Use sudo if outside of this script #######
################################################

/usr/local/bin/managed_python3 /usr/local/loopdown/loopdown -a garageband logicpro --i --pkg-server https://munki6.digiarts.mercy:8090/appleloops_content/loopdown --mandatory --optional

exit 0
