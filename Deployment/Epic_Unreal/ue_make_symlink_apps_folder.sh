ue_symlink='/Applications/Unreal Editor.app'

if [ -d "$ue_symlink" ]; then
   echo "Found app alias"
else
   ln -s '/Users/Shared/Epic Games/UE_5.4/Engine/Binaries/Mac/UnrealEditor.app' '/Applications/Unreal Editor.app'
fi
