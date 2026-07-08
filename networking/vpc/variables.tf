# VPC resource variables

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC resources"
  type        = string
}

variable "vpc_tags" {
  description = "VPC tags"
  type        = map(string)
}