#!/bin/bash

"/Volumes/Install Maya 2019/Install Maya 2019.app/Contents/MacOS/setup" --noui
"/Volumes/Install Maya 2019/Install Maya 2019.app/Contents/Resources/adlmreg" -i S 657K1 657K1 2019.0.0.F 399-54594761 /Library/Application\ Support/Autodesk/Adlm/PIT/2019/MayaConfig.pit

mkdir /Library/Application\ Support/Autodesk/CLM/LGS/657K1_2019.0.0.F
touch /Library/Application\ Support/Autodesk/CLM/LGS/657K1_2019.0.0.F/LGS.data
chmod 777 /Library/Application\ Support/Autodesk/CLM/LGS/657K1_2019.0.0.F/LGS.data
echo "_STANDALONE" > /Library/Application\ Support/Autodesk/CLM/LGS/657K1_2019.0.0.F/LGS.data
