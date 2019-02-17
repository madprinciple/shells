#!/bin/bash

cd /home/anton/testDir
file_count=$(ls -ltr /home/anton/testDir | awk '{print $9}' | sed -n '/file/p' | grep -v 'gz' | wc -l) #geting non zipped file count 

if [ $file_count -ge 5 ] ; then  #starting to zip  if non zipped file count is greater than 5
    ls -ltr /home/anton/testDir | awk '{print $9}' | sed -n '/file/p' | grep -v 'gz' | head -2 | xargs gzip -fv # always keeping 3 files non zipped
else
     echo "file count is not greater than 5"
fi
