#!/bin/bash

# 20190430
# Folders and files dropped off in "Drop-off-here" folders often
# have bad permissions. This script (intended for scheduled run on Synology NAS)
# goes through each class folder, finds Drop-off-here, adds rw to everthing, then
# fixes write-only at top level.

# TO DO: correct share name, test on NAS

IFS=$'\n'
# CART
cd '/volume1/CART-Class-folders'
pwd
for classFolder in `ls -d *`; do
    # pwd
    for innerFolder in `ls -d $classFolder/*`; do
#      echo $innerFolder
      if [[ "$classFolder/$innerFolder" =~ "Drop-off-here" ]]; then
        echo "found one at $classFolder/$innerFolder"
#        chmod -R a+rx $classFolder/$innerFolder
#        chmod o-r+w $classFolder/$innerFolder
      fi
    done
    # cd ..
  pwd
done

# MTEC
cd '/volume1/MTEC-Class-folders'
pwd
for classFolder in `ls -d *`; do
    # pwd
    for innerFolder in `ls -d $classFolder/*`; do
#      echo $innerFolder
      if [[ "$classFolder/$innerFolder" =~ "Drop-off-here" ]]; then
        echo "found one at $classFolder/$innerFolder"
#        chmod -R a+rx $classFolder/$innerFolder
#        chmod o-r+w $classFolder/$innerFolder
      fi
    done
    # cd ..
  pwd
done
