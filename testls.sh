#!/bin/bash
#
# check for non-existent file, exit status will be 2
#
ls somefile.ext
echo "status: $?"

# create file, and do again, exit status will be 0
touch somefile.ext
ls somefile.ext
echo "status: $?"

# remove the file to clean up
rm somefile.ext
