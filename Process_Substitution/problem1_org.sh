#!/bin/bash

sample_output() {
    echo 1 2
    echo 3 4
    echo 5 6
}

find_max() {
    x=0
    y=0

    sample_output | while read x1 y1 ; do
        [ $x1 -gt $x ] && x=$x1
        [ $y1 -gt $y ] && y=$y1
    done
    echo $x $y
}

find_max
