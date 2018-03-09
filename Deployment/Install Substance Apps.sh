#!/bin/sh

# Assumes folder on admin Desktop with installers and license files


sudo rm -R /Applications/Substance\ Designer.app/

cd /

sudo /usr/sbin/installer -pkg /Users/admin/Desktop/Allegorithmic/Substance_Designer-2017.2.1-590-mac-x64-standard-full.pkg -target /

sudo rm -R /Applications/Substance\ Painter.app/

sudo /usr/sbin/installer -pkg /Users/admin/Desktop/Allegorithmic/Substance_Painter-2017.3.1-1893-mac-x64-standard-full.pkg -target /

sudo mv /Users/admin/Desktop/Allegorithmic/license-Substance\ Designer.key /Library/Application\ Support/Allegorithmic/Substance\ Designer/license.key

sudo mv /Users/admin/Desktop/Allegorithmic/Substance\ Painter.key /Library/Application\ Support/Allegorithmic/Substance\ Painter/license.key

sudo chmod -R 755 /Library/Application\ Support/Allegorithmic/
