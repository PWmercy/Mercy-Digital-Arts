
# 20191210

# This script has been added to Task Scheduler on CATA-NAS1

# Folders and files dropped off in "Drop-off-here" folders often
# have bad permissions for instructor. This script goes through
# each class folder, finds Drop-off-here, adds rw to everything,
# then fixes write-only at top level.


IFS=$'\n'
# CART
cd '/volume1/CART-Class-folders'

for classFolder in `ls -d *`; do
    for innerFolder in `ls -d $classFolder/*`;  do
      if [[ $innerFolder =~ "Drop-off-here" ]]; then
      # echo "found one at $innerFolder"
       chmod -R a+rx $innerFolder
       chmod o-r+w $innerFolder
        # touch $innerFolder/foundit.txt
      fi
    done
done

# MTEC
cd '/volume1/MTEC-Class-folders'

for classFolder in `ls -d *`; do
    for innerFolder in `ls -d $classFolder/*`; do
      if [[ $innerFolder =~ "Drop-off-here" ]]; then
      # echo "found one at $innerFolder"
       chmod -R a+rx $innerFolder
       chmod o-r+w $innerFolder
        # touch $innerFolder/foundit.txt
      fi
    done
done
