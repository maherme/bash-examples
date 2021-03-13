#!/bin/bash
#
# This script calculates the factorial of a number passed as an argument

n=$1
[ "$n" == "" ] && echo Please give a number and try again && exit

factorial=1 ; j=1

until [ $j -gt $n ]
do
    factorial=$(( $factorial * $j ))
    j=$(($j+1))
done
echo The factorial of $n, "$n"'!' = $factorial
exit 0
