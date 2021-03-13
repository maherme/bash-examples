#!/bin/bash

# Functions
func1(){
    echo "This message is from function 1"
}
func2(){
    echo "This message is from function 2"
}
func3(){
    echo "This message is from function 3"
}

# prompt the user to get their choice
echo "Enter a number from 1 to 3"
read n

if [ $n -gt 0 ] && [ $n -lt 4 ]; then
    func$n
else
    echo "Wrong number entered"
fi
