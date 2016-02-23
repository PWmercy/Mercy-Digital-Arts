#!/bin/bash
<<<<<<< HEAD
<<<<<<< HEAD

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
=======
=======
>>>>>>> Test-branch
num=0
while [ $num -le 100 ]
do
#huh
echo $num

rem=($num % 2)

if [ $rem -eq 0 ]

then
echo "Even"
fi

#((num=num+1))
#((num++)) # also works
((num+=5))
<<<<<<< HEAD
>>>>>>> Test-branch
=======
>>>>>>> Test-branch

done
