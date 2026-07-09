# Route Table outputs

output "route_table_id" {
  value       = aws_route_table.route_table.id
  description = "ID of the public Route Table"
}

output "private_route_table_ids" {
  value       = aws_route_table.private_route_table[*].id
  description = "IDs of the private Route Tables"
}