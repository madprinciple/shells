#!/bin/bash

flavor=$( sed -n '/PRETTY_NAME/p' /etc/*release | cut -d "=" -f2 | sed 's/"//g' | awk '{print $1}' )
echo $flavor

case $flavor in
     Ubuntu)
     echo "Hello I'm Ubuntu" ;;
     CentOS)
     echo "Hello I'm CentOS" ;;
     *)
     echo "Who the fuck are you" ;;
esac

