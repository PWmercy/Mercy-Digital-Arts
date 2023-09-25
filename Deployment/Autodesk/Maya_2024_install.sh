#!/bin/sh

# From Slack
# https://macadmins.slack.com/archives/C08MY7GVC/p1689256490743869

#Set variables

year="2024"
pkgPath1="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/MayaUSD.pkg"
pkgPath2="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/Maya_AdLMconf2024.pkg"
pkgPath3="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Licensing/adlmflexnetserverIPV6.pkg"
#pkgpath4a="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Licensing/adskflexnetserverIPV6.pkg"
pkgPath5="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Licensing/AdskLicensing-13.0.0.8122-mac-installer.pkg"
pkgPath6="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/Maya_core2024.pkg"
pkgPath7="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/bifrost.pkg"
pkgPath8="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/MtoA.pkg"
pkgPath9="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/AdobeSubstance3DforMaya-2.3.2-2024-mac-universal.pkg"
pkgPath10="/tmp/Install Maya 2024.app/Contents/Helper/Packages/Maya/LookdevX.pkg"

pKey="657P1"
serial="302-29761870"
licPath="/Library/Application Support/Autodesk/AdskLicensingService/${pKey}_${year}.0.0.F"
licFile="LICPATH.lic"
lgsFile="LGS.data"

#Declare functions

runInstaller ()
{
    /usr/sbin/installer -verboseR -pkg "${pkgPath1}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath2}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath3}" -target /
    #/usr/sbin/installer -verboseR -pkg "${pkgPath4a}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath5}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath6}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath7}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath8}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath9}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath10}" -target /
}

createLicenseFiles ()
{
    if [[ ! -e "${licPath}" ]];
    then
        /bin/mkdir "${licPath}"
    fi
    /usr/bin/touch "${licPath}/${lgsFile}"
    /bin/chmod 777 "${licPath}/${lgsFile}"
    /usr/bin/touch "${licPath}/${licFile}"
    /bin/chmod 777 "${licPath}/${licFile}"
    /bin/echo "SERVER ${networkServer} 000000000000" > "${licPath}/${licFile}"
    /bin/echo "USE_SERVER" >> "${licPath}/${licFile}"
    /bin/echo "_NETWORK" >> "${licPath}/${lgsFile}"
}

chmod -R 777 /Library/Application\ Support/Autodesk/*

sleep 5

licenceHelper ()
{
        /Library/Application\ Support/Autodesk/AdskLicensing/Current/helper/AdskLicensingInstHelper register --pk ${pKey} --pv ${year}.0.0.F --lm STANDALONE --sn ${serial} --cf /Applications/Autodesk/maya2024/adlmreg/MayaConfig.pit --nu
}
cleanUp ()
{
    /bin/rm -rf "${pkgPath}"
    /bin/rm -rf "${tmpfile}"
   
}

#Run script
runInstaller
createLicenseFiles
licenceHelper
cleanUp