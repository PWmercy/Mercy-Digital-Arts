#!/bin/bash

BASEURL="http://munki5.digiarts.mercy/report/"
INSTALLROOT=""
MUNKIPATH="/usr/local/munkireport/"
CACHEPATH="${MUNKIPATH}scripts/cache/"
POSTFLIGHT_CACHEPATH="${MUNKIPATH}scripts/cache/"
PREFPATH="/Library/Preferences/MunkiReport"
PREF_CMDS=( ) # Pref commands array
TARGET_VOLUME=''
CURL=("/usr/bin/curl" "--fail" "--silent" "--show-error")
POSTFLIGHT_SCRIPT="postflight"
REPORT_BROKEN_CLIENT_SCRIPT="report_broken_client"
# Exit status
ERR=0

# Packaging
BUILDPKG=0
IDENTIFIER="com.github.munkireport"
RESULT=""

VERSION="5.2.0"
VERSIONLONG="5.2.0.3922"

function usage {
	PROG=$(basename $0)
	cat <<EOF >&2
Usage: ${PROG} [OPTIONS]

  -b URL    Base url to munki report server
            Current value: ${BASEURL}
  -m PATH   Path to installation directory
            Current value: ${MUNKIPATH}
  -p PATH   Path to preferences file (without the .plist extension)
            Current value: ${PREFPATH}
  -i PATH   Create a full installer at PATH
  -c ID     Change pkg id to ID
  -h        Display this help message
  -r PATH   Path to installer result plist
  -v VERS   Override version number

Example:
  * Install munkireport client scripts into the default location.

        $PROG

  * Install munkireport and preferences into a custom location ready to be
    packaged.

        $PROG -b ${BASEURL} \\
              -m ~/Desktop/munkireport-$VERSION/usr/local/munkireport/ \\
              -p ~/Desktop/munkireport-$VERSION/Library/Preferences/MunkiReport \\
              -n

  * Create a package installer for munkireport.

        $PROG -i ~/Desktop
EOF
}

# Set munkireport preference
function setpref {
	PREF_CMDS=( "${PREF_CMDS[@]}" "defaults write \"\${TARGET}\"${PREFPATH} ${1} \"${2}\"" )
}

# Set munkireport reportitem preference
function setreportpref {
	setpref "ReportItems -dict-add ${1}" "${2}"
}

# Reset reportitems
function resetreportpref {
	PREF_CMDS=( "${PREF_CMDS[@]}" "defaults write \"\${TARGET}\"${PREFPATH} ReportItems -dict" )
}

while getopts b:m:p:r:c:v:i:h flag; do
	case $flag in
		b)
			BASEURL="$OPTARG"
			;;
		m)
			MUNKIPATH="$OPTARG"
			;;
		p)
			PREFPATH="$OPTARG"
			;;
		r)
			RESULT="$OPTARG"
			;;
		c)
			IDENTIFIER="$OPTARG"
			;;
		v)
			VERSION="$OPTARG"
			;;
		i)
			PKGDEST="$OPTARG"
			# Create temp directory
			INSTALLTEMP=$(mktemp -d -t mrpkg)
			INSTALLROOT="$INSTALLTEMP"/install_root
			MUNKIPATH="$INSTALLROOT"/usr/local/munkireport/
			TARGET_VOLUME='$3'
			PREFPATH="/Library/Preferences/MunkiReport"
			BUILDPKG=1

			;;
		h|?)
			usage
			exit
			;;
	esac
done

# build additional HTTP headers
if [ "$(defaults read "${PREFPATH}" UseMunkiAdditionalHttpHeaders 2>/dev/null)" = "1" ]; then
	BUNDLE_ID='ManagedInstalls'
	MANAGED_INSTALLS_PLIST_PATHS=("${TARGET_VOLUME}/private/var/root/Library/Preferences/${BUNDLE_ID}.plist" "${TARGET_VOLUME}/Library/Preferences/${BUNDLE_ID}.plist")
	ADDITIONAL_HTTP_HEADERS_KEY='AdditionalHttpHeaders'
	ADDITIONAL_HTTP_HEADERS=()
	for plist in "${MANAGED_INSTALLS_PLIST_PATHS[@]}"; do
		while IFS= read -r line; do
			if [[ "$line" =~ \"([^\"]+) ]]; then
				ADDITIONAL_HTTP_HEADERS+=("${BASH_REMATCH[1]}")
			fi
		done <<< "$(defaults read "${plist%.plist}" "$ADDITIONAL_HTTP_HEADERS_KEY")"
	done
	for header in "${ADDITIONAL_HTTP_HEADERS[@]}"; do CURL+=("-H" "$header"); done
fi

echo "# Preparing ${MUNKIPATH}"
mkdir -p "${MUNKIPATH}munkilib"
mkdir -p "${MUNKIPATH}scripts"
mkdir -p "${INSTALLROOT}/Library/MunkiReport/Logs"

# Create preflight.d symlinks
rm -rf "${MUNKIPATH}preflight.d" &&  ln -s "scripts" "${MUNKIPATH}preflight.d"
rm -rf "${MUNKIPATH}postflight.d" && ln -s "scripts" "${MUNKIPATH}postflight.d"

mkdir -p "${INSTALLROOT}/usr/local/munki"
mkdir -p "${INSTALLROOT}/Library/LaunchDaemons"

#Normalize BASEURL so it has a trailing slash.
if [[ ${BASEURL: -1} != "/" ]]
then
    BASEURL="${BASEURL}/"
fi

echo "BaseURL is ${BASEURL}"
TPL_BASE="${BASEURL}assets/client_installer/payload"

echo "# Retrieving munkireport scripts"
SCRIPTS=$("${CURL[@]}" "${BASEURL}index.php?/install/get_paths")

for SCRIPT in $SCRIPTS; do
	echo "${INSTALLROOT}${SCRIPT}"
	"${CURL[@]}" "${TPL_BASE}${SCRIPT}" --output "${INSTALLROOT}${SCRIPT}" || ERR=1
done

if [ $ERR = 1 ]; then
	echo "Failed to download all required components! Cleaning up.."
	for SCRIPT in $SCRIPTS; do
		rm -f "${INSTALLROOT}${SCRIPT}"
	done
	exit 1
fi

chmod a+x "${INSTALLROOT}/usr/local/munki/"{${POSTFLIGHT_SCRIPT},${REPORT_BROKEN_CLIENT_SCRIPT}}
chmod a+x "${INSTALLROOT}/usr/local/munkireport/munkireport-runner"


echo "Configuring munkireport"
#### Configure Munkireport ####

# Set BaseUrl preference
setpref 'BaseUrl' "${BASEURL}"

# Reset ReportItems array
resetreportpref

# Include module scripts

## applications ##
echo '+ Installing applications'

#!/bin/bash

# applications controller
CTL="${BASEURL}index.php?/module/applications/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/applications.py" -o "${MUNKIPATH}preflight.d/applications.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/applications.py"

	# Set preference to include this file in the preflight check
	setreportpref "applications" "${CACHEPATH}applications.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/applications.py"

	# Signal that we had an error
	ERR=1
fi




## appusage ##
echo '+ Installing appusage'

#!/bin/bash

MODULE_NAME="appusage"
MODULE_CACHE_FILE="appusage.csv"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/appusage" -o "${MUNKIPATH}preflight.d/appusage"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/appusage"
	mkdir -p "${MUNKIPATH}preflight.d/cache"
	touch "${MUNKIPATH}preflight.d/cache/${MODULE_CACHE_FILE}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/appusage"

	# Signal that we had an error
	ERR=1
fi


## ard ##
echo '+ Installing ard'

#!/bin/bash

MODULE_NAME="ard"
MODULESCRIPT="init_ard"
PREF_FILE="/Library/Preferences/com.apple.RemoteDesktop.plist"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${PREF_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi

## bluetooth ##
echo '+ Installing bluetooth'

#!/bin/bash

# bluetooth controller
CTL="${BASEURL}index.php?/module/bluetooth/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/bluetooth.py" -o "${MUNKIPATH}preflight.d/bluetooth.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/bluetooth.py"

	# Set preference to include this file in the preflight check
	setreportpref "bluetooth" "${CACHEPATH}bluetoothinfo.plist"

	# Remove old shell bluetooth script if it exists
	rm -f "${MUNKIPATH}preflight.d/bluetooth.sh"
else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/bluetooth.{sh,py}"

	# Signal that we had an error
	ERR=1
fi




## caching ##
echo '+ Installing caching'

#!/bin/bash

MODULE_NAME="caching"
MODULESCRIPT="caching"
MODULE_CACHE_FILE="caching.txt"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"
	touch "${MUNKIPATH}preflight.d/cache/${MODULE_CACHE_FILE}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


## certificate ##
echo '+ Installing certificate'

#!/bin/bash

MODULE_NAME="certificate"
MODULESCRIPT="cert_check"
PREF_FILE="certificate.txt"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${PREF_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


## directory_service ##
echo '+ Installing directory_service'

#!/bin/bash

# directory service controller
CTL="${BASEURL}index.php?/module/directory_service/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/directoryservice.sh" -o "${MUNKIPATH}preflight.d/directoryservice.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/directoryservice.sh"

	# Set preference to include this file in the preflight check
	setreportpref "directory_service" "${CACHEPATH}directoryservice.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/directoryservice.sh"

	# Signal that we had an error
	ERR=1
fi




## disk_report ##
echo '+ Installing disk_report'

#!/bin/bash

# disk_report controller
DR_CTL="${BASEURL}index.php?/module/disk_report/"

# Get the scripts in the proper directories
"${CURL[@]}" "${DR_CTL}get_script/disk_info" -o "${MUNKIPATH}preflight.d/disk_info"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/disk_info"

	# Set preference to include this file in the preflight check
	setreportpref "disk_report" "${CACHEPATH}disk.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/disk_info"
	ERR=1
fi




## displays_info ##
echo '+ Installing displays_info'

#!/bin/bash

# Displays_info controller
CTL="${BASEURL}index.php?/module/displays_info/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/displays.py" -o "${MUNKIPATH}preflight.d/displays.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/displays.py"

	# Delete the older style cached file
	if [[ -f "${MUNKIPATH}preflight.d/cache/displays.txt" ]] ; then
		rm -f "${MUNKIPATH}preflight.d/cache/displays.txt"
	fi

	# Set preference to include this file in the preflight check
	setreportpref "displays_info" "${CACHEPATH}displays.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/displays.py"

	# Signal that we had an error
	ERR=1
fi


## extensions ##
echo '+ Installing extensions'

#!/bin/bash

# extensions controller
CTL="${BASEURL}index.php?/module/extensions/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/extensions.py" -o "${MUNKIPATH}preflight.d/extensions.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/extensions.py"

	# Set preference to include this file in the preflight check
	setreportpref "extensions" "${CACHEPATH}extensions.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/extensions.py"

	# Signal that we had an error
	ERR=1
fi




## fan_temps ##
echo '+ Installing fan_temps'

#!/bin/bash

# fan_temps_controller
NW_CTL="${BASEURL}index.php?/module/fan_temps/"

# Get the script in the proper directory
"${CURL[@]}"  -s "${NW_CTL}get_script/fan_temps" -o "${MUNKIPATH}preflight.d/fan_temps"

# Only download smc.zip if smc doesn't exist
if [ ! -f "${MUNKIPATH}smc" ]; then
    "${CURL[@]}"  -s "${NW_CTL}get_script/smc.zip" -o "${MUNKIPATH}smc.zip"
fi

if [ "${?}" != 0 ]; then
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/fan_temps"
	rm -f "${MUNKIPATH}smc.zip"
	exit 1
else

    # Delete smckit
    if [ -f "${MUNKIPATH}smckit" ]; then
        rm -f "${MUNKIPATH}smckit"
    fi

    # Delete fan_temps.sh
    if [ -f "${MUNKIPATH}preflight.d/fan_temps.sh" ]; then
        rm -f "${MUNKIPATH}preflight.d/fan_temps.sh"
    fi

	# Unzip the executable only if it exists
	if [ -f "${MUNKIPATH}smc.zip" ]; then
	     unzip  -oqq "${MUNKIPATH}smc.zip" -d "${MUNKIPATH}"
	fi

	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/fan_temps"
	chmod a+x "${MUNKIPATH}smc"

	# Clean up smc.zip only if it exists
	if [ -f "${MUNKIPATH}smc.zip" ]; then
	     rm -f "${MUNKIPATH}smc.zip"
	fi

	# Set preference to include this file in the preflight check
	setreportpref "fan_temps" "${CACHEPATH}fan_temps.plist"
fi

## filevault_escrow ##
echo '+ Installing filevault_escrow'

#!/bin/bash

# crypt output file
CRYPT_OUTPUT_PLIST="/var/root/crypt_output.plist"

# Set preference to include this file in the preflight check
setreportpref "filevault_escrow" "${CRYPT_OUTPUT_PLIST}"


## filevault_status ##
echo '+ Installing filevault_status'

#!/bin/bash

# filevault_status_controller
FV_CTL="${BASEURL}index.php?/module/filevault_status/"

# Get the scripts in the proper directories
"${CURL[@]}" "${FV_CTL}get_script/filevaultstatus" -o "${MUNKIPATH}preflight.d/filevaultstatus" \

# Check exit status of curl
if [ $? = 0 ]; then
	# Make script executable
	chmod a+x "${MUNKIPATH}preflight.d/filevaultstatus"

	# Set preference to include this file in the preflight check
	setreportpref "filevault_status" "${CACHEPATH}filevault_status.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/filevaultstatus"

	# Set the exit status
	ERR=1
fi



## findmymac ##
echo '+ Installing findmymac'

#!/bin/bash

# findmymac_manifest controller
CTL="${BASEURL}index.php?/module/findmymac/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/findmymac.sh" -o "${MUNKIPATH}preflight.d/findmymac.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/findmymac.sh"

	# Set preference to include this file in the preflight check
	setreportpref "findmymac" "${CACHEPATH}findmymac.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/findmymac.sh"

	# Signal that we had an error
	ERR=1
fi


## fonts ##
echo '+ Installing fonts'

#!/bin/bash

# fonts controller
CTL="${BASEURL}index.php?/module/fonts/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/fonts.py" -o "${MUNKIPATH}preflight.d/fonts.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/fonts.py"

	# Set preference to include this file in the preflight check
	setreportpref "fonts" "${CACHEPATH}fonts.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/fonts.py"

	# Signal that we had an error
	ERR=1
fi




## gpu ##
echo '+ Installing gpu'

#!/bin/bash

# gpu controller
CTL="${BASEURL}index.php?/module/gpu/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/gpu.py" -o "${MUNKIPATH}preflight.d/gpu.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/gpu.py"

	# Set preference to include this file in the preflight check
	setreportpref "gpu" "${CACHEPATH}gpuinfo.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/gpu.py"

	# Signal that we had an error
	ERR=1
fi




## homebrew ##
echo '+ Installing homebrew'

#!/bin/bash

# homebrew controller
CTL="${BASEURL}index.php?/module/homebrew/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/homebrew.sh" -o "${MUNKIPATH}preflight.d/homebrew.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/homebrew.sh"

	# Touch the cache file to prevent errors
	mkdir -p "${MUNKIPATH}preflight.d/cache"
	touch "${MUNKIPATH}preflight.d/cache/homebrew.json"

	# Set preference to include this file in the preflight check
	setreportpref "homebrew" "${CACHEPATH}homebrew.json"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/homebrew.sh"

	# Signal that we had an error
	ERR=1
fi




## homebrew_info ##
echo '+ Installing homebrew_info'

#!/bin/bash

# homebrew_info controller
CTL="${BASEURL}index.php?/module/homebrew_info/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/homebrew_info.sh" -o "${MUNKIPATH}preflight.d/homebrew_info.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/homebrew_info.sh"

	# Touch the cache file to prevent errors
	mkdir -p "${MUNKIPATH}preflight.d/cache"
	touch "${MUNKIPATH}preflight.d/cache/homebrew_info.json"

	# Set preference to include this file in the preflight check
	setreportpref "homebrew_info" "${CACHEPATH}homebrew_info.json"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/homebrew_info.sh"

	# Signal that we had an error
	ERR=1
fi




## installhistory ##
echo '+ Installing installhistory'

#!/bin/bash

# Add InstallHistory (in 10.5 you need SWU.log)

# Get major OS version (uses uname -r and bash substitution)
# osvers is 10 for 10.6, 11 for 10.7, 12 for 10.8, etc.
osversionlong=$(uname -r)
osvers=${osversionlong/.*/}

if (( $osvers < 10 )); then
	IPATH="/Library/Logs/Software Update.log"
else
	IPATH="/Library/Receipts/InstallHistory.plist"
fi

setreportpref "installhistory" "${IPATH}"


## inventory ##
echo '+ Installing inventory'

#!/bin/bash

# inventory controller
DR_CTL="${BASEURL}index.php?/module/inventory/"

# Find out where the munki directory is to set accordingly.
munki_install_dir=$(/usr/bin/python -c 'import CoreFoundation; print CoreFoundation.CFPreferencesCopyAppValue("ManagedInstallDir", "ManagedInstalls")')
munki_install_dir=$(echo ${munki_install_dir} | sed 's/\/$//')

# Get the scripts in the proper directories
"${CURL[@]}" "${DR_CTL}get_script/inventory_add_plugins" -o "${MUNKIPATH}postflight.d/inventory_add_plugins.py"

# Check exit status of curl
if [ $? = 0 ]; then
    # Make executable
    chmod a+x "${MUNKIPATH}postflight.d/inventory_add_plugins.py"
    # make sure the munki install directory is defined. If not default back to normal
    if [[ "${munki_install_dir}" == "None" ]]; then
        # This also intended behavior if munki isn't installed
        setreportpref "inventory" '/Library/Managed Installs/ApplicationInventory.plist'
    else
        # Set preference to include this file in the preflight check
        setreportpref "inventory" "${munki_install_dir}/ApplicationInventory.plist"
    fi
else
    echo "Failed to download all required components!"
    rm -f "${MUNKIPATH}postflight.d/inventory_add_plugins.py"
    ERR=1
fi


## localadmin ##
echo '+ Installing localadmin'

#!/bin/bash

# localadmin controller
CTL="${BASEURL}index.php?/module/localadmin/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/localadmin" -o "${MUNKIPATH}preflight.d/localadmin"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/localadmin"

	# Set preference to include this file in the preflight check
	setreportpref "localadmin" "${CACHEPATH}localadmins.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/localadmin"

	# Signal that we had an error
	ERR=1
fi




## location ##
echo '+ Installing location'

#!/bin/bash

# Path to location directory and pref
LOCATION_DIR="/Library/Application Support/pinpoint"
LOCATION_PREF="${LOCATION_DIR}/location.plist"
MODULESCRIPT="init_location"
MODULE_NAME="location"

# map controller
CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref "${MODULE_NAME}" "${LOCATION_PREF}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi

# Remove old testing script and cache if they exist
files=( "${MUNKIPATH}preflight.d/location.py" "${MUNKIPATH}preflight.d/cache/location.plist" )
for i in "${files[@]}"
do
	/bin/rm -f $i
done






## managedinstalls ##
echo '+ Installing managedinstalls'

#!/bin/bash

# Remove previous script and plist from preflight.d
rm -f "${MUNKIPATH}preflight.d/managedinstalls.py"
rm -f "${MUNKIPATH}preflight.d/cache/managedinstalls.plist"

# managedinstalls controller
CTL="${BASEURL}index.php?/module/managedinstalls/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/managedinstalls.py" -o "${MUNKIPATH}postflight.d/managedinstalls.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}postflight.d/managedinstalls.py"

	# Set preference to include this file in the preflight check
	setreportpref "managedinstalls" "${POSTFLIGHT_CACHEPATH}managedinstalls.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}postflight.d/managedinstalls.py"

	# Signal that we had an error
	ERR=1
fi


## mdm_status ##
echo '+ Installing mdm_status'

#!/bin/bash

MODULE_NAME="mdm_status"
MODULESCRIPT="mdm_status.py"
MODULE_CACHE_FILE="mdm_status.plist"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


## munki_facts ##
echo '+ Installing munki_facts'

#!/bin/bash

MODULE_NAME="munki_facts"
MODULESCRIPT="munki_facts.py"
MODULE_CACHE_FILE="munki_facts.plist"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}postflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
  # Make executable
  chmod a+x "${MUNKIPATH}postflight.d/${MODULESCRIPT}"

  # Set preference to include this file in the postflight check
  setreportpref $MODULE_NAME "${POSTFLIGHT_CACHEPATH}${MODULE_CACHE_FILE}"

else
  echo "Failed to download all required components!"
  rm -f "${MUNKIPATH}postflight.d/${MODULESCRIPT}"

  # Signal that we had an error
  ERR=1
fi


## munkiinfo ##
echo '+ Installing munkiinfo'

#!/bin/bash

MODULE_NAME="munkiinfo"
MODULESCRIPT="munkiinfo.py"
MODULE_CACHE_FILE="munkiinfo.plist"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


## munkireport ##
echo '+ Installing munkireport'

#!/bin/bash

# Remove previous script and plist from preflight.d
rm -f "${MUNKIPATH}preflight.d/munkireport.py"
rm -f "${MUNKIPATH}preflight.d/cache/munkireport.plist"

# managedinstalls controller
CTL="${BASEURL}index.php?/module/munkireport/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/munkireport.py" -o "${MUNKIPATH}postflight.d/munkireport.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}postflight.d/munkireport.py"

	# Set preference to include this file in the preflight check
	setreportpref "munkireport" "${POSTFLIGHT_CACHEPATH}munkireport.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}postflight.d/munkireport.py"

	# Signal that we had an error
	ERR=1
fi


## munkireportinfo ##
echo '+ Installing munkireportinfo'

#!/bin/bash

# munkireportinfo_controller
NW_CTL="${BASEURL}index.php?/module/munkireportinfo/"

# Get the script in the proper directory
"${CURL[@]}" "${NW_CTL}get_script/munkireportinfo" -o "${MUNKIPATH}preflight.d/munkireportinfo"

if [ "${?}" != 0 ]
then
	echo "Failed to download all required components!"
	rm -f ${MUNKIPATH}preflight.d/munkireportinfo
	exit 1
fi

# Make executable
chmod a+x "${MUNKIPATH}preflight.d/munkireportinfo"

# Set preference to include this file in the preflight check
setreportpref "munkireportinfo" "${CACHEPATH}munkireportinfo.plist"


## network ##
echo '+ Installing network'

#!/bin/bash

# network_controller
NW_CTL="${BASEURL}index.php?/module/network/"

# remove the previous networkinfo.sh if installed
rm -f "${MUNKIPATH}preflight.d/networkinfo.sh"

# Get the script in the proper directory
"${CURL[@]}" "${NW_CTL}get_script/networkinfo.py" -o "${MUNKIPATH}preflight.d/networkinfo.py"

if [ "${?}" != 0 ]
then
	echo "Failed to download all required components!"
	rm -f ${MUNKIPATH}preflight.d/networkinfo.py
	exit 1
fi

# Make executable
chmod a+x "${MUNKIPATH}preflight.d/networkinfo.py"

# Set preference to include this file in the preflight check
setreportpref "network" "${CACHEPATH}networkinfo.plist"


## network_shares ##
echo '+ Installing network_shares'

#!/bin/bash

# network_shares controller
CTL="${BASEURL}index.php?/module/network_shares/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/network_shares.py" -o "${MUNKIPATH}preflight.d/network_shares.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/network_shares.py"

	# Set preference to include this file in the preflight check
	setreportpref "network_shares" "${CACHEPATH}network_shares.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/network_shares.py"

	# Signal that we had an error
	ERR=1
fi




## power ##
echo '+ Installing power'

#!/bin/bash

# power controller
CTL="${BASEURL}index.php?/module/power/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/power.sh" -o "${MUNKIPATH}preflight.d/power.sh"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/power.sh"

	# Set preference to include this file in the preflight check
	setreportpref "power" "${CACHEPATH}powerinfo.plist"

    # Delete the older style cached file
    if [[ -f "${MUNKIPATH}preflight.d/cache/powerinfo.txt" ]] ; then
         rm -f "${MUNKIPATH}preflight.d/cache/powerinfo.txt"
    fi

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/power.sh"

	# Signal that we had an error
	ERR=1
fi


## printer ##
echo '+ Installing printer'

#!/bin/bash

# printer controller
CTL="${BASEURL}index.php?/module/printer/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/printer.py" -o "${MUNKIPATH}preflight.d/printer.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/printer.py"

	# Set preference to include this file in the preflight check
	setreportpref "printer" "${CACHEPATH}printer.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/printer.py"

	# Signal that we had an error
	ERR=1
fi



## profile ##
echo '+ Installing profile'

#!/bin/bash

# profile controller
CTL="${BASEURL}index.php?/module/profile/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/profile.py" -o "${MUNKIPATH}preflight.d/profile.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/profile.py"

	# Set preference to include this file in the preflight check
	setreportpref "profile" "${CACHEPATH}profile.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/profile.py"

	# Signal that we had an error
	ERR=1
fi


## security ##
echo '+ Installing security'

#!/bin/bash

MODULE_NAME="security"
MODULESCRIPT="security.py"
MODULE_CACHE_FILE="security.plist"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Remove old versions of the script and cache file
if [ -f "${MUNKIPATH}preflight.d/security.sh" ]; then
	rm "${MUNKIPATH}preflight.d/security.sh"
fi

if [ -f "${MUNKIPATH}preflight.d/cache/security.txt" ]; then
	rm "${MUNKIPATH}preflight.d/cache/security.txt"
fi


# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


## smart_stats ##
echo '+ Installing smart_stats'

#!/bin/bash

# smart_stats_controller
CTL="${BASEURL}index.php?/module/smart_stats/"

# Get the script in the proper directory

"${CURL[@]}" "${CTL}get_script/smart_stats.sh" -o "${MUNKIPATH}preflight.d/smart_stats.sh"

if [ "${?}" != 0 ]
then
	echo "Failed to download all required components!"
	rm -f ${MUNKIPATH}preflight.d/smart_stats.sh
	exit 1
else
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/smart_stats.sh"

	# Set preference to include this file in the preflight check
	setreportpref "smart_stats" "${CACHEPATH}smart_stats.plist"
fi

## softwareupdate ##
echo '+ Installing softwareupdate'

#!/bin/bash

# softwareupdate controller
CTL="${BASEURL}index.php?/module/softwareupdate/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/softwareupdate" -o "${MUNKIPATH}preflight.d/softwareupdate"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/softwareupdate"

	# Set preference to include this file in the preflight check
    setreportpref "softwareupdate" "${CACHEPATH}softwareupdate.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/softwareupdate"

	# Signal that we had an error
	ERR=1
fi


## supported_os ##
echo '+ Installing supported_os'

#!/bin/bash

# supported_os controller
CTL="${BASEURL}index.php?/module/supported_os/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/supported_os" -o "${MUNKIPATH}preflight.d/supported_os"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/supported_os"

	# Set preference to include this file in the preflight check
	setreportpref "supported_os" "${CACHEPATH}supported_os.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/supported_os"

	# Signal that we had an error
	ERR=1
fi




## timemachine ##
echo '+ Installing timemachine'

#!/bin/bash

# time machine controller
CTL="${BASEURL}index.php?/module/timemachine/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/timemachine" -o "${MUNKIPATH}preflight.d/timemachine"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/timemachine"

	# Set preference to include this file in the preflight check
	setreportpref "timemachine" "${CACHEPATH}timemachine.plist"

	# Delete the older style txt cache file
	if [[ -f "${MUNKIPATH}preflight.d/cache/timemachine.txt" ]] ; then
	     rm -f "${MUNKIPATH}preflight.d/cache/timemachine.txt"
	fi

	# Delete the older timemachine.sh
	if [[ -f "${MUNKIPATH}preflight.d/timemachine.sh" ]] ; then
	     rm -f "${MUNKIPATH}preflight.d/timemachine.sh"
	fi

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/timemachine"

	# Signal that we had an error
	ERR=1
fi


## usage_stats ##
echo '+ Installing usage_stats'

#!/bin/bash

# usage_stats controller
CTL="${BASEURL}index.php?/module/usage_stats/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/usage_stats" -o "${MUNKIPATH}preflight.d/usage_stats"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/usage_stats"

	# Set preference to include this file in the preflight check
	setreportpref "usage_stats" "${CACHEPATH}usage_stats.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/usage_stats"

	# Signal that we had an error
	ERR=1
fi




## usb ##
echo '+ Installing usb'

#!/bin/bash

# usb controller
CTL="${BASEURL}index.php?/module/usb/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/usb.py" -o "${MUNKIPATH}preflight.d/usb.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/usb.py"

	# Set preference to include this file in the preflight check
	setreportpref "usb" "${CACHEPATH}usbinfo.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/usb.py"

	# Signal that we had an error
	ERR=1
fi




## user_sessions ##
echo '+ Installing user_sessions'

#!/bin/bash

# user_sessions controller
CTL="${BASEURL}index.php?/module/user_sessions/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/user_sessions.py" -o "${MUNKIPATH}preflight.d/user_sessions.py"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/user_sessions.py"

	# Set preference to include this file in the preflight check
	setreportpref "user_sessions" "${CACHEPATH}user_sessions.plist"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/user_sessions.py"

	# Signal that we had an error
	ERR=1
fi




## warranty ##
echo '+ Installing warranty'

#!/bin/bash

# warranty controller
CTL="${BASEURL}index.php?/module/warranty/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/warranty" -o "${MUNKIPATH}preflight.d/warranty"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/warranty"

	# Set preference to include this file in the preflight check
	setreportpref "warranty" "${CACHEPATH}warranty.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/warranty"

	# Signal that we had an error
	ERR=1
fi




## wifi ##
echo '+ Installing wifi'

#!/bin/bash

MODULE_NAME="wifi"
MODULESCRIPT="wifi"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
"${CURL[@]}" "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	setreportpref $MODULE_NAME "${CACHEPATH}${MODULE_NAME}.txt"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi


# Store munkipath when building a package
if [ $BUILDPKG = 1 ]; then
	STOREPATH=${MUNKIPATH}
	MUNKIPATH='$3/usr/local/munkireport/'
	CACHEPATH="\$3${CACHEPATH}"
	POSTFLIGHT_CACHEPATH="\$3${POSTFLIGHT_CACHEPATH}"
fi

# Capture uninstall scripts
read -r -d '' UNINSTALLS << EOF


## backup2go ##
echo '- Uninstalling backup2go'

#!/bin/bash

# Remove backup2go script
rm -f "${MUNKIPATH}preflight.d/backup2go.sh"

# Remove backup2go.txt file
rm -f "${MUNKIPATH}preflight.d/cache/backup2go.txt"


## crashplan ##
echo '- Uninstalling crashplan'

#!/bin/bash

rm -f "${MUNKIPATH}preflight.d/crashplan.py"
rm -f "${CACHEPATH}crashplan.txt"



## deploystudio ##
echo '- Uninstalling deploystudio'

#!/bin/bash

# Remove warranty script
rm -f "${MUNKIPATH}preflight.d/deploystudio"

# Remove deploystudio.txt file
rm -f "${CACHEPATH}deploystudio.txt"


## detectx ##
echo '- Uninstalling detectx'

#!/bin/bash

# Remove homebrew.json file
rm -f "${CACHEPATH}detectx.json"


## devtools ##
echo '- Uninstalling devtools'

#!/bin/bash

# Remove devtools script
rm -f "${MUNKIPATH}preflight.d/devtools.py"

# Remove devtools.plist file
rm -f "${CACHEPATH}devtools.plist"


## gsx ##
echo '- Uninstalling gsx'

#!/bin/bash

# Remove gsx script
rm -f "${MUNKIPATH}preflight.d/gsx"

# Remove gsx.txt file
rm -f "${CACHEPATH}gsx.txt"


## ibridge ##
echo '- Uninstalling ibridge'

#!/bin/bash

# Remove ibridge script
rm -f "${MUNKIPATH}preflight.d/ibridge.py"

# Remove ibridge.plist file
rm -f "${CACHEPATH}ibridge.plist"


## mbbr_status ##
echo '- Uninstalling mbbr_status'

#!/bin/bash

# Remove mbbr_status script
rm -f "${MUNKIPATH}preflight.d/mbbr_status.py"

# Remove malwarebytes.plist file
rm -f "${CACHEPATH}malwarebytes.plist"


## sccm_status ##
echo '- Uninstalling sccm_status'


#!/bin/bash

# Remove SCCM Status script
rm -f "${MUNKIPATH}preflight.d/sccm_status_info.sh"

# Remove SCCM Status file
rm -f "${MUNKIPATH}preflight.d/cache/sccm_status.txt"



## sentinelone ##
echo '- Uninstalling sentinelone'

#!/bin/bash

# Remove preflight script
rm -f "${MUNKIPATH}preflight.d/sentinelone.py"

# Remove cache file
rm -f "${CACHEPATH}sentinelone.plist"


## sentinelonequarantine ##
echo '- Uninstalling sentinelonequarantine'

#!/bin/bash

# Remove preflight script
rm -f "${MUNKIPATH}preflight.d/sentinelone_quarantine.py"

# Remove cache file
rm -f "${CACHEPATH}sentinelone_quarantine.plist"


## sophos ##
echo '- Uninstalling sophos'

#!/bin/bash

MODULE_NAME="sophos"
MODULESCRIPT="sophos.py"
MODULE_CACHE_FILE="sophos.plist"

# Remove preflight script
rm -f "${MUNKIPATH}preflight.d/sophos.py"

# Remove cache file
rm -f "${CACHEPATH}sophos.plist"


EOF

# Restore munkipath when building a package
if [ $BUILDPKG = 1 ]; then
	MUNKIPATH=${STOREPATH}
fi


# If not building a package, execute uninstall scripts
if [ $BUILDPKG = 0 ]; then
	eval "$UNINSTALLS"
	# Remove munkireport version file
	rm -f "${MUNKIPATH}"munkireport-*.*.*
fi

if [ $ERR = 0 ]; then

	if [ $BUILDPKG = 1 ]; then

		# Create scripts directory
		SCRIPTDIR="$INSTALLTEMP"/scripts
		mkdir -p "$SCRIPTDIR"

		# Add uninstall script to preinstall
		echo  "#!/bin/bash" > $SCRIPTDIR/preinstall
		# Add uninstall scripts
		echo  "$UNINSTALLS" >> $SCRIPTDIR/preinstall
		chmod +x $SCRIPTDIR/preinstall

		# Add Preference setting commands to postinstall
		echo  "#!/bin/bash" > $SCRIPTDIR/postinstall
        cat >>$SCRIPTDIR/postinstall <<EOF
if [[ "\$3" == "/" ]]; then
    TARGET=""
	/bin/launchctl unload /Library/LaunchDaemons/com.github.munkireport.runner.plist
    /bin/launchctl load /Library/LaunchDaemons/com.github.munkireport.runner.plist
else
    TARGET="\$3"
fi

EOF

		for i in "${PREF_CMDS[@]}";
			do echo $i >> $SCRIPTDIR/postinstall
		done
        echo "defaults write \"\${TARGET}\"${PREFPATH} Version ${VERSIONLONG}" >> $SCRIPTDIR/postinstall
		chmod +x $SCRIPTDIR/postinstall


		echo "Building MunkiReport v${VERSION} package."
		pkgbuild --identifier "$IDENTIFIER" \
				 --version "$VERSION" \
				 --root "$INSTALLROOT" \
				 --scripts "$SCRIPTDIR" \
				 "$PKGDEST/munkireport-${VERSION}.pkg"

		if [[ $RESULT ]]; then
			defaults write "$RESULT" version ${VERSION}
			defaults write "$RESULT" pkg_path "$PKGDEST/munkireport-${VERSION}.pkg"
		fi

	else

		echo "Preparing ${PREFPATH}"
		mkdir -p "$(dirname ${PREFPATH})"

		# Set preferences
		echo "Setting preferences"
		for i in "${PREF_CMDS[@]}"; do
			eval $i
		done

		# Set munkireport version file
		touch "${MUNKIPATH}munkireport-${VERSION}"
        defaults write ${PREFPATH} Version ${VERSIONLONG}

		echo 'Loading MunkiReport LaunchDaemon'
		/bin/launchctl unload /Library/LaunchDaemons/com.github.munkireport.runner.plist &>/dev/null
		/bin/launchctl load /Library/LaunchDaemons/com.github.munkireport.runner.plist


		echo "Installation of MunkiReport v${VERSION} complete."

	fi

else
	echo "! Installation of MunkiReport v${VERSION} incomplete."
fi

if [ "$INSTALLTEMP" != "" ]; then
	echo "Cleaning up temporary directory $INSTALLTEMP"
	rm -r $INSTALLTEMP
fi



exit $ERR
