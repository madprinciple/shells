#!/bin/bash
clear
cat serverlist.txt
echo ""
echo "Please enter the server from above list"
read asg
echo ""
case "$asg" in
  MyTestserverASG)
     echo -e "Your selction is \e[33m$asg \e[39mand here are the running instances releated to your input ..."
     instance_id=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $asg --query 'AutoScalingGroups[].Instances[?HealthStatus==`Healthy`].InstanceId')
     instance_id=$(echo $instance_id | awk '{print $1}')
     instance_name=$(aws ec2 describe-instances --instance $instance_id --query "Reservations[].Instances[].[Tags[?Key=='Name']]")
     instance_name=$(echo $instance_name | awk '{ print $2 }')
     instance_ip=$(aws ec2 describe-instances --instance $instance_id --query "Reservations[].Instances[].PrivateIpAddress")
     instance_zone=$(aws ec2 describe-instances --instance i-0d057a094ef50ede5 --query "Reservations[].Instances[].Placement[].AvailabilityZone")
     echo ""
     echo -e "\e[33m$instance_name  $instance_id  $instance_ip  $instance_zone"
     echo -e "\e[39m"
     echo "Please confirm to continue with AMI creation (Y/N) "
     read confirmation1
         case "$confirmation1" in
         Y)
          echo "server is rebooting... AMI is creating ..."
          ami_id=$(aws ec2 create-image --instance-id $instance_id --name "$instance_name-$(date '+%Y%m%d')" --description "$(date '+%Y%m%d')" --query ImageId --output text)
          echo "AMI is successfully created"
          echo ""
          aws ec2 create-tags --resources $ami_id --tags Key=Name,Value="$instance_name-$(date '+%Y%m%d')"   #tagging
          echo -e "\e[33m$instance_name-$(date '+%Y%m%d')   $ami_id"
          echo -e "\e[39m"
          echo "Do you want to Configure the AMI into Auto Scaling Group (Y/N)"
          read confirmation2
             case "$confirmation2" in
             Y)
              echo "creating Launch configuration ..."
              aws autoscaling create-launch-configuration --launch-configuration-name $instance_name-ASLC-$(date '+%Y%m%d') --image-id $ami_id --cli-input-json file://server1-ASLC.json
              sleep 5
              lc_name=$(aws autoscaling describe-launch-configurations --launch-configuration-names $instance_name-ASLC-$(date '+%Y%m%d') --query 'LaunchConfigurations[*].LaunchConfigurationName')
              echo "Launch configuration is created."
              echo " "
              echo -e "\e[33m$lc_name"
              echo -e "\e[39m"
              echo -e "Updating Auto Scaling Group : \e[33m$asg \e[39m..."
              aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lc_name
              lc_verified_name=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $asg --query 'AutoScalingGroups[].LaunchConfigurationName')
              echo -e "Auto scaling Group:  \e[33m$asg  \e[39mis updated with Launch configuration :\e[33m$lc_verified_name"
              echo -e "\e[39m"
              ;;
             *)
              echo "ASG Configuring is cancelled by user"
              ;;
             esac
          ;;
         *)
          echo "AMI creation is cancelled by user"
          ;;
         esac
      ;;
     *)
     echo "you have input the invalid ASG name"
;;
esac
