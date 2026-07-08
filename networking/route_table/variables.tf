# Route Table module variables

variable "route_table_vpc_id" {
  description = "VPC ID where the route table will be created"
  type        = string
}

variable "route_table_internet_gateway_id" {
  description = "Internet Gateway ID for the public route"
  type        = string
}

variable "route_table_public_subnet_ids" {
  description = "List of public subnet IDs to associate with the route table"
  type        = list(string)
}

variable "route_table_tags" {
  description = "Tags for the Route Table"
  type        = map(string)
}