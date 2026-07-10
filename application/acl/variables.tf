variable "vpc_id" {
  description = "VPC ID where the network ACLs will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate with the public ACL"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate with the private ACL"
  type        = list(string)
}
