
#!/bin/bash
IFS=$'\n'
for folder in `ls .`; do
  echo $folder
  if [[ "$folder" =~ "Drop-off" ]]; then
    echo "found one"
    chmod -R a+rx $folder
    chmod o-r+w $folder
  fi
done
