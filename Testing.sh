IFS=$'\n'
# CART
cd '/Applications'

for appFolder in `ls -d *`; do
    for innerFolder in $appFolder/*; do
      echo $innerFolder
    done
done
