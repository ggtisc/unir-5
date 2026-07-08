# Module variables

# VPC module variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC resources"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_tags" {
  description = "VPC tags"
  type        = map(string)

  default = {
    "Name"        = "vpc-0001-us-east2",
    "Description" = "VPC name tag"
  }
}

# Subnet module variables
variable "public_subnet_cidr_block" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnet_cidr_block" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "data_subnet_cidr_block" {
  description = "CIDR blocks for data tier private subnets"
  type        = list(string)
  default     = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}

# Internet Gateway module variables
variable "internet_gateway_tags" {
  description = "Internet Gateway tags"
  type        = map(string)

  default = {
    "Name"        = "vpc-0001-ig-us-east2",
    "Description" = "Internet Gateway to allow internet access to the public subnets"
  }
}

# Route Table module variables
variable "route_table_tags" {
  description = "Route Table tags"
  type        = map(string)

  default = {
    "Name"        = "vpc-0001-us-east2-public-route-table",
    "Description" = "Public Route Table for internet access"
  }
}

variable "vpc_endpoint_service_name" {
  description = "Service name for any gateway VPC endpoint to create (e.g. com.amazonaws.us-east-1.s3)"
  type        = string
  default     = "com.amazonaws.us-east-2.s3"
}