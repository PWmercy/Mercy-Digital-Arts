#!/bin/sh

if  [[ -e "/Applications/ZBrush 2022 FL/Uninstall/Uninstall ZBrush 2022.app" ]]; then

cd "/Applications/ZBrush 2022 FL/Uninstall/Uninstall ZBrush 2022.app/Contents/MacOS"

##### CHECK CPU TYPE #####

cpu_type=$(sysctl -a | grep brand)

if [[ $cpu_type =~ ""Intel"" ]]; then

     ./osx-x86_64 --mode unattended

  elif [[ $cpu_type =~ ""Apple"" ]]; then

	./osx-arm64 --mode unattended

  fi
  

fi

