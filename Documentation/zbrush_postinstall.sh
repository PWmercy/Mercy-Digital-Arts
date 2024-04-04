#!/bin/sh

cd '/tmp/ZBrush_2024.0.1_Installer.app/Contents/MacOS/'


##### CHECK CPU TYPE #####

cpu_type=$(sysctl -a | grep brand)

if [[ $cpu_type =~ ""Intel"" ]]; then

     osx-x86_64 --mode unattended --unattendedmodeui none

elif [[ $cpu_type =~ ""Apple"" ]]; then

	./osx-arm64  --mode unattended --unattendedmodeui none

fi


rm -R "/tmp/ZBrush_2024.0.1_Installer.app"