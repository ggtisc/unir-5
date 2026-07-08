# Terraform AWS Data Sources Configuration

data "aws_region" "main_region" {}                  # Get the current AWS region
data "aws_caller_identity" "terraform_account" {}   # Get information about the AWS account

data "aws_availability_zones" "available" {         # Get the list of available availability zones, util to know all the available availability zones in the region
  state = "available"                               # for creating resources across multiple AZs like subnets
}                                                   # With this data source, you can dynamically retrieve the list of AZs and create multiple resources