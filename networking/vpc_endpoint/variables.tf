# Variables for VPC Endpoint module

variable "vpc_id" {
  description = "VPC ID where the endpoint will be created"
  type        = string
}

variable "service_name" {
  description = "Service name for the VPC endpoint (e.g. com.amazonaws.<region>.s3)"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with the gateway endpoint"
  type        = list(string)
}

variable "vpc_endpoint_tags" {
  description = "Tags to apply to the VPC endpoint"
  type        = map(string)
  default     = {}
}
