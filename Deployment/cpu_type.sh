#!/bin/bash

### This script was created as part of the post-install script for
## Zbrush 2022, because there are different install binaries for each

cpu_type=$(sysctl -a | grep brand)

# echo $cpu_type

if [[ $cpu_type =~ ""Intel"" ]]; then

  echo "Intel"

elif [[ $cpu_type =~ ""Apple"" ]]; then

	echo "Apple Silicon"

fi
