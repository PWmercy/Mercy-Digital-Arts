#!/bin/sh

#Instructions for next time
#Import install disk image with munkiimport
#Change installer_type to copy_from_dmg
#Copy installer app to /tmp
#Modify values below as necessary (Usually: year and pKey)

#Set variables

year="2022"
pkgPath1="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/MayaUSD.pkg"
pkgPath2="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/Maya_AdLMconf2022.pkg"
pkgPath3="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Licensing/adlmflexnetserverIPV6.pkg"
pkgPath4="/tmp/Install Maya 2022.app/Contents/Helper/Packages/AdSSO/AdSSO-v2.pkg"
pkgpath4a="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Licensing/adlmframework18.pkg"
pkgPath5="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Licensing/AdskLicensing-11.0.0.4854-mac-installer.pkg"
pkgPath6="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/Maya_core2022.pkg"
pkgPath7="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/bifrost.pkg"
pkgPath8="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/MtoA.pkg"
pkgPath9="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/SubstanceInMaya-2.1.9-2022-Darwin.pkg"
pkgPath10="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/motion-library.maya2022-2.0.0.pkg"
pkgPath11="/tmp/Install Maya 2022.app/Contents/Helper/Packages/Maya/Pymel2022.pkg"

pKey="657N1"
networkServer="[your server]"
licPath="/Library/Application Support/Autodesk/AdskLicensingService/${pKey}_${year}.0.0.F"
licFile="LICPATH.lic"
lgsFile="LGS.data"

#Declare functions

runInstaller ()
{
    /usr/sbin/installer -verboseR -pkg "${pkgPath1}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath2}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath3}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath4}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath4a}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath5}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath6}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath7}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath8}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath9}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath10}" -target /
    /usr/sbin/installer -verboseR -pkg "${pkgPath11}" -target /
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
licenceHelper ()
{
    /Library/Application\ Support/Autodesk/AdskLicensing/Current/helper/AdskLicensingInstHelper change --pk "${pKey}" --pv "${year}.0.0.F" --lm NETWORK --ls "${networkServer}"
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
