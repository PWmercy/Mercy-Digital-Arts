#!/bin/bash

cpu_type=$(sysctl -a | grep brand)

# echo $cpu_type

if [[ $cpu_type =~ ""Intel"" ]]; then

  echo "Intel"

elif [[ $cpu_type =~ ""Apple"" ]]; then

	echo "Apple Silicon"

fi
