#!/usr/bin/env bash
#
# This script will configure an environment to complete the Advanced Auto Scaling workbook
# https://portal2010.amazon.com/sites/aws-support-training/_layouts/WordViewer.aspx?id=/sites/aws-support-training/New%20Hire%20Training/Advanced%20Training/AutoScaling%2BSelf-Paced%2BAssignment.docx&Source=https%3A%2F%2Fportal2010%2Eamazon%2Ecom%2Fsites%2Faws%2Dsupport%2Dtraining%2FNew%2520Hire%2520Training%2FForms%2FAllItems%2Easpx%3FRootFolder%3D%252Fsites%252Faws%252Dsupport%252Dtraining%252FNew%2520Hire%2520Training%252FAdvanced%2520Training%26FolderCTID%3D0x0120001D4D9A6E25B01949BCC224C242CA1F79%26View%3D%257bC03&DefaultItemOpen=1&DefaultItemOpen=1
#

## Variables
_srcDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${_srcDir}/variables/advanced_autoscaling
. ${_srcDir}/variables/global

## Methods
. ${_srcDir}/methods/ec2/_key-pair
. ${_srcDir}/methods/ec2/_security-group
. ${_srcDir}/methods/ec2/_instances
. ${_srcDir}/methods/elb/_elb
. ${_srcDir}/methods/autoscaler/_autoscaler
. ${_srcDir}/methods/misc/_apache

### Script Begin ###
function f_deploy(){
  # This will create or replace a key pair to be used for ssh
  echo -e "\t\tCreating a key pair..."
  f_test_key_pair

  # This will create an ec2 security group used for accessing services (SSH, HTTP)
  echo -e "\t\tCreating secruity group and adding ports..."
  f_create_security_group
  f_allow_ports

  # This will create an ec2 instance
  echo -e "\t\tCreating instance..."
  f_run_instances
  echo -e "\t\t\tNaming instance..."
  f_tag_instance
  echo -e "\t\t\tWaiting for instance..."
  f_wait_for_instance_state "running"


  # This will install and enable apache with a generic index.html
  echo -e "\t\t\tWaiting for SSH access..."
  f_wait_for_ssh
  echo -e "\t\tConfiguring Apache on instance..."
  f_yum_install_httpd
  f_create_index_html
  f_enable_start_httpd

  # This will create an Amazon Machine Image (AMI) for use with an ELB
  echo -e "\t\tCreating AMI..."
  f_create_image
  echo -e "\t\t\tWaiting for AMI creation..."
  f_wait_for_image

  # This will create an ELB to front our webserver
  echo -e "\t\tCreating ELB..."
  f_create_elb

  # This will create an Autoscaler Group
  echo -e "\t\tCreating Autoscaler..."
  echo -e "\t\t\tCreating Autoscaler launch configuration..."
  f_create_autoscaler_config
  echo -e "\t\t\tCreating Autoscaler group..."
  f_create_autoscaler_group

  # Create Autoscaler Policies
  echo -e "\t\t\tCreating Autoscaler policies..."
  f_create_autoscale_policy "${v_autoscaler_policy_name_scalein}" "${v_autoscaler_policy_scalein}" > ${_srcDir}/cache/as_policy_scalein.arn
  f_create_autoscale_policy "${v_autoscaler_policy_name_scaleout}" "${v_autoscaler_policy_scaleout}" > ${_srcDir}/cache/as_policy_scaleout.arn

  # Create CloudWatch alarm-actions
  echo -e "\t\tCreating CloudWatch alarms..."
  f_create_cloudwatch_alarm "${v_cloudwatch_alarm_name_scalein}" "`cat ${_srcDir}/cache/as_policy_scalein.arn`"
  f_create_cloudwatch_alarm "${v_cloudwatch_alarm_name_scaleout}" "`cat ${_srcDir}/cache/as_policy_scaleout.arn`"

  # Terminate uneeded instance
  echo -e "\t\tTerminating original instance"
  f_terminate_instances
}

function f_print_help(){
  echo -e "\n\tUsage: ${_srcDir}/`basename \"$0\"` [ --deploy | --cleanup ]\n"
}
while true; do
  case $1 in
    --deploy* )
      echo -e "\n\tDeploying Advanced AutoScaling environment...\n"
      echo -e "\t\tThis might take a few minutes, go grab a cofee.\n"
      f_deploy
      break
      ;;
    --cleanup* )
      echo -e "\n\tTearing down Advanced AutoScaling environment...\n"
      f_cleanup
      break
      ;;
    * )
      f_print_help
      break
      ;;
  esac
done
### Script End ###
