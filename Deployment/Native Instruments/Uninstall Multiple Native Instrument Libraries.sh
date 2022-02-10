#!/bin/sh

# Uninstall Native Instruments Software from a Mac Computer

# Based on
# https://support.native-instruments.com/hc/en-us/articles/210291865-How-to-Uninstall-Native-Instruments-Software-from-a-Mac-Computer

##### Which product? #####

# echo "What is the name of the product?"


declare -a StringArray=(
"Abbey Road 50s Drummer"
"Abbey Road 60s Drummer"
"Abbey Road 70s Drummer"
"Abbey Road 80s Drummer"
"Abbey Road Modern Drummer"
"Abbey Road Vintage Drummer"
"Action Strings"
"Arkhis"
"Blocks Base"
"Blocks Primes"
"Butch Vig Drums"
"Choral"
"Circuit Halo"
"Dirt"
"Driver"
"Expansions Selection"
"Enhanced EQ"
"EXHALE"
"Flair"
"George Duke Soul Treasures"
"Grey Forge"
"Guarneri Violin"
"Guitar Rig 5"
"Kinetic Treats"
"Kontour"
"Mallet Flux"
"Maschine Drum Selection"
"Mikro Prism"
"Our House"
"Phasis"
"Play Series Selection"
"Polyplex"
"Rammfire"
"Razor"
"Reaktor 5"
"Reflektor"
"Replika XT"
"REV X-LOOPS"
"Rounds"
"Sasha"
"Scarbee Jay-Bass"
"Scarbee MM-Bass Amped"
"Scarbee Pre-Bass Amped"
"Scarbee Rickenbacker Bass"
"Scarbee Vintage Keys"
"Session Guitarist - Electric Sunburst Deluxe"
"Session Guitarist - Electric Sunburst"
"Session Guitarist - Picked Acoustic"
"Session Guitarist - Strummed Acoustic 2"
"Session Guitarist - Strummed Acoustic"
"Session Strings Pro"
"Signal"
"Stradivari Cello"
"Stradivari Violin"
"SUBSTANCE"
"Super 8"
"Supercharger GT"
"Supercharger"
"Symphony Series Brass Ensemble"
"Symphony Series Brass Solo"
"Symphony Series Percussion"
"Symphony Series String Ensemble"
"Symphony Series Woodwind Ensemble"
"Symphony Series Woodwind Solo"
"The Gentleman"
"The Maverick"
"Traktors 12"
"Yangqin"
)

for prodname in "${StringArray[@]}"; do

echo "$prodname"

# read prodname

##### Application Files #####

rm -R "/Applications/Native Instruments/$prodname"
# (folder)

rm "/Library/Preferences/com.native-instruments.$prodname.plist"

##### Plug-in Files #####

rm -R "/Library/Audio/Plug-ins/Components/$prodname.component"
rm -R "/Library/Audio/Plug-ins/VST/$prodname.vst"
rm -R "/Library/Application Support/Digidesign/Plug-ins/$prodname.dpm"
rm -R "/Library/Application Support/Avid/Audio/Plug-ins/$prodname.aaxplugin"

##### App-specific Data and Support Files #####

rm -R "/Library/Application Support/Native Instruments/$prodname"
# (folder)

rm -R "/Library/Application Support/Native Instruments/Service Center/$prodname.xml"

##### Preferences Files (User Library) #####
#
# "/Users/*Your User Name*/Library/Preferences/com.native-instruments.$prodname.plist
#
# "/Users/*Your User Name*/Library/Application Support/Native Instruments/$prodname
# # (folder)

# Note: the User Library folder is hidden. To access it, click on Go in the menu bar and press down the Alt key. You'll now find the Library entry in the menu:
# User Library3 2.gif

# It is necessary to restart your computer after deleting the above-mentioned files to make the changes permanent.

##### Content Files #####

# Content such as KONTAKT, BATTERY, SESSION STRINGS, etc. will also have a library folder that can be deleted. It is located in the content directory you chose during installation. By default that is:

##### Folder may be named #####
rm -R "/Users/Shared/$prodname"
##### OR #####
rm -R "/Users/Shared/$prodname Library"

done

# You can find all the content products with their parent applications in this list."

# Note: it is NOT necessary to uninstall the library in most cases to fix common issues. You can safely leave this folder in place in most cases.
