#!/bin/bash

sample_output() {
    echo 1 2
    echo 3 4
    echo 5 6
}

find_max() {
    x=0
    y=0

    while read x1 y1 ; do
        [[ $x1 -gt $x ]] && x=$x1
        [[ $y1 -gt $y ]] && y=$y1
    done < <(sample_output)
    echo $x $y
}

find_max
