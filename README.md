### H3 This will deploy a test environment in AWS to show understanding of how autoscaling works.
#### H4 You must have AWS CLI installed and configured for this to work.

> `cd ~ && git clone https://github.com/matteary/advanced_autoscaling_workbook.git`
> `cd advanced_autoscaling_workbook`

Usage: ./advanced_autoscaling.sh [ --deploy | --cleanup | --increase-traffic | --help ]

  --deploy		Deploys the Advanced Autocaling Workbook environment
  --cleanup		Tears down the Advance Autoscaling Workbook environment
  --increase-traffic	Use Apache's benchmark tool to simulate load to websites
  --help		Displays this message

