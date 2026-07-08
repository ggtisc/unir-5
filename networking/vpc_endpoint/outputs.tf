# Outputs for VPC Endpoint module

output "vpc_endpoint_id" {
  value       = aws_vpc_endpoint.vpc_endpoint.id
  description = "ID of the created VPC endpoint"
}

output "vpc_endpoint_route_table_association_ids" {
  value       = aws_vpc_endpoint_route_table_association.association[*].id
  description = "IDs of the route table associations for the VPC endpoint"
}
