#!/bin/bash
cd /Users || exit
array=( bmaguire1 gmiceli lcasanova1 nsantana10 root )
for i in "${array[@]}"
do
rm -r $i
done
