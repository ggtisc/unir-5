# Subnet Resource Variables

variable "subnet_vpc_id" {
  description = "VPC ID for the subnet resources"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet resources"
  type        = list(string)
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for private subnet resources"
  type        = list(string)
}

variable "data_subnet_cidr_block" {
  description = "CIDR block for data tier private subnet resources"
  type        = list(string)
}

variable "subnet_availability_zone" {
  description = "Availability zone for the subnets"
  type        = list(string)
}

variable "subnet_tags" {
  description = "Subnet tags"
  type        = map(string)
}