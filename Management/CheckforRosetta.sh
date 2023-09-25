#!/bin/bash

# test for Rosetta
if /usr/bin/pgrep oahd >/dev/null 2>&1; then
echo "Rosetta installed"
else
	echo "Rosetta Missing"
fi
