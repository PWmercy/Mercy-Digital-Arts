#!/bin/sh

# Install or update Apple packages for Logic and Garageband (and MainStage if installed)

# Assumes install and location of appleloops and managed_python https://github.com/macadmins/python
# Assumes location of content on http server

# Use sudo if outside of this script
/usr/local/bin/managed_python3 /usr/local/bin/appleloops --deployment --pkg-server http://munki6.digiarts.mercy:8090/appleloops_content --mandatory --optional

exit 0
