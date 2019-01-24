#!/bin/bash

for ip in $( cat  list.txt )
do
os_ver=$(ssh -Aq -o Batchmode=yes -o ConnectTimeout=3 root@$ip "sed -n '/PRETTY_NAME/p' /etc/*release | cut -d '=' -f2 ")
echo  "$ip -- $os_ver"
done
