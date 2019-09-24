#!/bin/bash
clear
>deletelist.txt
flag=0
asg=MyTestserverASG-ASLC
aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName' --output json | grep $asg  | tr -d '"| |,'>deletelist.txt
echo -e "Delete older LCs and AMIs \e[33m$asg \e[39m(Y/N) or press 'D' to delete the oldest LC"
read confirmation3
case "$confirmation3" in
 Y)
 echo " "
 echo "Please enter the LC name to delete"
 echo " "
 cat deletelist.txt
 echo ""
 echo "please enter your selction"
 read input_lc
   for delete_lc in $( cat deletelist.txt )
    do
      if [ "$delete_lc" == "$input_lc" ];
        then
         delete_imageid=$(aws autoscaling describe-launch-configurations --launch-configuration-names $delete_lc --query 'LaunchConfigurations[*].ImageId')
         lc_createdate=$(aws autoscaling describe-launch-configurations --launch-configuration-names $delete_lc --query 'LaunchConfigurations[*].[CreatedTime]' | sed 's/T/ /g' | cut -f1 -d ".")
         echo ""
         echo -e "\e[33m$delete_lc   $delete_imageid  $lc_createdate \e[39m"
         echo "Confirm to Delete(Y/N)"
         read confirmation4
         case "$confirmation4" in
           Y)
            echo "Deleting $delete_lc .."
            aws autoscaling delete-launch-configuration --launch-configuration-name $delete_lc
            aws ec2 deregister-image --image-id $delete_imageid
            echo "Remaining LCs are "
            echo ""
            aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName' --output json | grep $asg  | tr -d '"| |,'
            echo ""
            flag=1
            ;;
           *)
            echo "Not deleting any LCs. Exiting.."
            ;;
          esac
      fi
    done
      if [ "$flag" -ne "1" ]
        then
        echo "your input is invalid no LCs have been deleted"
        exit 0
      fi
 echo ""
 ;;
  d|D)
  echo ""
  cat deletelist.txt
  echo ""
  oldest_lc=$(sort deletelist.txt | head -1)
  echo -e "Deleting the oldest => \e[33m$oldest_lc \e[39m"
  delete_oldest_imageid=$(aws autoscaling describe-launch-configurations --launch-configuration-names $oldest_lc --query 'LaunchConfigurations[*].ImageId')
  aws autoscaling delete-launch-configuration --launch-configuration-name $oldest_lc
  aws ec2 deregister-image --image-id $delete_oldest_imageid
 ;;
 *)
 echo "Invalid input no LCs have been deleted. Exiting .."
 ;;
esac
>deletelist.txt
flag=0
exit 0


