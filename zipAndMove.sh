#!/bin/bash

cd /home/anton/testDir

zipped_count=$(ls -la | grep .gz |wc -l)
back_file_count=$(($zipped_count -2))

if [ $zipped_count -ge 3 ]; then 
   ls -ltr | grep .gz | awk '{print $9}'| sed -n '/file/p' | head -n $back_file_count >listToSend.txt
   rsync -av --remove-source-files --files-from=listToSend.txt /home/anton/testDir/ root@node-01:/backups
   cp /home/anton/testDir/listToSend.txt /home/anton/testDir/sentList_$(date +%F-%H:%M).txt
   >/home/anton/testDir/listToSend.txt
else
     echo "file count is not greater than 3 : Todays backup was not executed"
fi
