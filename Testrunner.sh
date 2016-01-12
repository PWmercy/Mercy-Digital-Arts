#!/bin/bash

num=1
read -p "Divisor: " divisor

echo $divisor

while [ $num -le 100 ]

do

# echo -n $num

#rem=$(expr $num % 2)

# if [ $rem -eq 0 ]
if [ $(expr $num % $divisor) -eq 0 ]

then
echo "$num is divisible by $divisor"
#printf "\n"
fi
#printf "\n"
#((num=num+1))
#((num++)) # also works
((num++))

done
