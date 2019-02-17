#!/bin/bash

cd /home/anton/testDir
file_count=$(ls -ltr /home/anton/testDir | awk '{print $9}' | sed -n '/file/p' | grep -v 'gz' | wc -l)

if [ $file_count -ge 5 ] ; then
    ls -ltr /home/anton/testDir | awk '{print $9}' | sed -n '/file/p' | grep -v 'gz' | head -2 | xargs gzip -fv
else
     echo "file count is not greater than 5"
fi
