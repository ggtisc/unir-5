# Internet Gateway resource variables

variable "internet_gateway_vpc_id" {
  description = "Internet Gateway VPC ID"
  type        = string
}

variable "internet_gateway_tags" {
  description = "Internet Gateway tags"
  type        = map(string)
}