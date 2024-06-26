#!/bin/sh

if  [[ -e "/Applications/Maxon ZBrush 2023/Uninstall/Uninstall Maxon ZBrush.app" ]]; then

cd "/Applications/Maxon ZBrush 2023/Uninstall/Uninstall Maxon ZBrush.app/Contents/MacOS"

##### CHECK CPU TYPE #####
 
cpu_type=$(sysctl -a | grep brand)

if [[ $cpu_type =~ ""Intel"" ]]; then
    ./osx-x86_64 --mode unattended

elif [[ $cpu_type =~ ""Apple"" ]]; then
    ./osx-arm64 --mode unattended
    
fi

fi