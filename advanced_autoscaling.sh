#!/usr/bin/env bash
#
# This script will configure an environment to complete the Advanced Auto Scaling workbook
# https://portal2010.amazon.com/sites/aws-support-training/_layouts/WordViewer.aspx?id=/sites/aws-support-training/New%20Hire%20Training/Advanced%20Training/AutoScaling%2BSelf-Paced%2BAssignment.docx&Source=https%3A%2F%2Fportal2010%2Eamazon%2Ecom%2Fsites%2Faws%2Dsupport%2Dtraining%2FNew%2520Hire%2520Training%2FForms%2FAllItems%2Easpx%3FRootFolder%3D%252Fsites%252Faws%252Dsupport%252Dtraining%252FNew%2520Hire%2520Training%252FAdvanced%2520Training%26FolderCTID%3D0x0120001D4D9A6E25B01949BCC224C242CA1F79%26View%3D%257bC03&DefaultItemOpen=1&DefaultItemOpen=1
#

## Variables
_srcDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${_srcDir}/variables/global

## workers
. ${_srcDir}/workers/_deploy
. ${_srcDir}/workers/_cleanup
. ${_srcDir}/workers/_increase_traffic
. ${_srcDir}/workers/_help
. ${_srcDir}/workers/ec2/_key-pair
. ${_srcDir}/workers/ec2/_security-group
. ${_srcDir}/workers/ec2/_instances
. ${_srcDir}/workers/elb/_elb
. ${_srcDir}/workers/autoscaler/_autoscaler
. ${_srcDir}/workers/misc/_apache
. ${_srcDir}/workers/cloudwatch/_cloudwatch

### Script Begin ###
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
    --increase-traffic* )
      echo -e "\n\tIncreasing traffic to $(f_get_elb_dnsname)"
      f_increase_traffic
      break
      ;;
    * )
      f_print_help
      break
      ;;
  esac
done
### Script End ###
