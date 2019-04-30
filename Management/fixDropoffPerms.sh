#!/bin/bash

# 20190430
# Folders and files dropped off in "Drop-off-here" folders often
# have bad permissions. This script (intended for scheduled run on Synology NAS)
# goes through each class folder, finds Drop-off-here, adds rw to everthing, then
# fixes write-only at top level.

# TO DO: correct share name, test on NAS

IFS=$'\n'
cd 'FakeShare'
pwd
for classFolder in `ls -d *`; do
    # pwd
    for innerFolder in `ls -d $classFolder/*`; do
      echo $innerFolder
      if [[ "$classFolder/$innerFolder" =~ "Drop-off" ]]; then
        echo "found one"
        chmod -R a+rx $classFolder/$innerFolder
        chmod o-r+w $classFolder/$innerFolder
      fi
    done
    # cd ..
  pwd
done
