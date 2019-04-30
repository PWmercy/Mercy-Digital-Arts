
#!/bin/bash
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
