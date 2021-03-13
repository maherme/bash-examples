#!/bin/bash

# prompts the user for a directory name and then creates it with mkdir.
echo "Please enter a directory name:"
read NEW_DIR

# save original directory so we can return to it
ORIG_DIR=$(pwd)

# check to make sure it doesn't already exist.
[[ -d $NEW_DIR ]] && echo $NEW_DIR already exists, aborting && exit
mkdir $NEW_DIR

# changes to the new directory and prints out where it is using pwd.
cd $NEW_DIR
pwd

# using touch, creates several empty files and runs ls on them to verify
# they are empty.
for n in 1 2 3 4
do
    touch file$n
done

ls file?

# puts some content in them using echo and redirection.
for names in file?
do
    echo This file is named $names > $names
done

# displays their content using cat.
cat file?

# says goodbye to the user and cleans up after itself.
cd $ORIG_DIR
rm -rf $NEW_DIR
echo "Goodbye $USER !!!"
