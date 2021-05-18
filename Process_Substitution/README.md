The code can be analized in two parts:

Part 1:
```bash
sample_output() {
    echo 1 2
    echo 3 4
    echo 5 6
}
```
This function is sending pairs of numbers through the standard output, you can watch from the echo man page: 

DESCRIPTION
       Echo the STRING(s) to standard output.

Part 2:
```bash
find_max() {
    x=0
    y=0

    sample_output | while read x1 y1 ; do
        [ $x1 -gt $x ] && x=$x1
        [ $y1 -gt $y ] && y=$y1
    done
    echo $x $y
}
```
This function is creating a pipeline using the control operator |. A pipeline connects the output of the left side process of the | operator to the input of the right side process, so:

program_1 | program_2 | program_3 ...

The above command is connecting the output of program_1 to the input of program_2, and the output of program_2 to the input of program_3 and so on.
It is very important to know that bash will lauch all these programs in parallel and it configures their inputs and outputs accordingly.

So in this particular case the output of "sample_output" is connected to the input of "while read x1 y1", so basically it is storing the values of each "echo" command from "sample_output" inside the "x1" and "y1" variables. But remember the sentence above about launching program in parallel, and also take into account this sentence from pipeline section in bash man page:

Each command in a pipeline is executed as a separate process (i.e., in a subshell).

So, please, keep in mind after executing the control operator | , a pipe is created and you have two processes, you can execute this modified script in a terminal to see this behaviour:
```bash
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
        sleep 3600 # I want to pause the execution just after creating the pipe
        [ $x1 -gt $x ] && x=$x1
        [ $y1 -gt $y ] && y=$y1
    done
    echo $x $y
}
find_max
```
And in other terminal you can watch the processes which are running using $ ps -elf, you should see something like this:
```console
[maherme@localhost Process_Substitution]$ ps -elf
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
0 S maherme     7960    7953  0  80   0 - 58384 -      12:40 pts/0    00:00:00 bash
0 S maherme    18594    7960  0  80   0 - 55553 -      19:24 pts/0    00:00:00 bash problem1_org.sh
1 S maherme    18596   18594  0  80   0 - 55553 -      19:24 pts/0    00:00:00 bash problem1_org.sh
0 S maherme    18597   18596  0  80   0 - 55166 -      19:24 pts/0    00:00:00 sleep 3600
```
Take into account there are two processes of problem1_org.sh (I named problem1_org.sh the script above), and one is the parent of the other. Remember, the memory map of the child and parent processes are different, so the value of a variable modified in a child process is not modified in its parent. So the assignments "x=$x1" and "y=$y1" will take effect only in the child process, not in the parent process.

The line [ $x1 -gt $x ] && x=$x1 is using the concept of short-circuit evaluation:
oper1 and oper2 -> if oper1 is "false", oper2 will never be executed, because "false" and "whatever" is "false".
                   if oper1 is "true", oper2 will be executed, because "true" and "whatever" is "whatever".
This line can be written as: if [ $x1 -gt $x ]; then x=$x1; fi

So this script is intended to print the greatest number of each column for all the pairs of values that the sample_output function is sending to the standard output. But what the script is really doing is printing "0 0", because the variables "x" and "y" are modified in a subshell, so their values are not going to be modified outside the while loop.

In order to fix this problem I suggest to use the "process substitution":
Process substitution runs the commands, saves their output into a temporary file and then passes that file name in place of the command. This temporary file is an unnamed pipe that is removed automatically once it is no longer needed.
My proposed solution to this problem is the following:
```bash
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
```
So, the sample_output function is executed and the result is passed through a pipe to the read as argument, so we avoid the problem of the variables in a different context (memory map).

You can find in this folder the files problem1_org.sh, the original script with the bug, and problem1_fixed.sh, the modified script with my proposed solution.
