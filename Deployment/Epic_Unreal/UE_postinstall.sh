#!/bin/bash 
 
# get latest version 
URVERSION=`ls /Users/Shared/Epic\ Games/` 
 
# symlink to Applications 
ln -s /Users/Shared/Epic\ Games/"${URVERSION}"/Engine/Binaries/Mac/UE4Editor.app /Applications/Unreal\ Editor.app 
 
## Allows access to create AutomationTool folder when building apps 
mkdir /Users/Shared/Epic\ Games/"${URVERSION}"/Engine/Programs/AutomationTool 
chmod a+rwx /Users/Shared/Epic\ Games/"${URVERSION}"/Engine/Programs/AutomationTool 
 
exit 0