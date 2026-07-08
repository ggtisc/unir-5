# Route Table outputs

output "route_table_id" {
  value       = aws_route_table.route_table.id
  description = "ID of the created Route Table"
}