#!/bin/bash

# test for Rosetta
if /usr/bin/pgrep oahd >/dev/null 2>&1; then
echo "installed"
else
	echo "Missing"
fi
