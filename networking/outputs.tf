# Module Outputs

# VPC outputs
output "vpc_id" {
  value       = module.vpc_00001.vpc_id
  description = "VPC id"
}

# Subnet outputs
output "public_subnets" {
  value       = module.subnets_00001.public_subnet_ids
  description = "public subnets"
}

output "private_subnets" {
  value       = module.subnets_00001.private_subnet_ids
  description = "private subnets"
}

output "data_subnets" {
  value       = module.subnets_00001.data_subnet_ids
  description = "data tier private subnets"
}

# Internet Gateway outputs
output "internet_gateway_id" {
  value       = module.internet_gateway_00001.internet_gateway_id
  description = "Internet Gateway id"
}

# Route Table outputs
output "route_table_id" {
  value       = module.route_table_00001.route_table_id
  description = "Route Table id"
}

# VPC Endpoint outputs
output "vpc_endpoint_id" {
  value       = module.vpc_endpoint.vpc_endpoint_id
  description = "ID of the created VPC endpoint"
}