#!/bin/bash 
 
# get latest version 
URVERSION='UE_5.4'
 
# symlink to Applications 

 
## Allows access to create AutomationTool folder when building apps 
mkdir /Users/Shared/Epic\ Games/"${URVERSION}"/Engine/Programs/AutomationTool 
chmod a+rwx /Users/Shared/Epic\ Games/"${URVERSION}"/Engine/Programs/AutomationTool 
 
exit 0