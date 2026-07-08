#Subnet outputs

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "ID of the created public subnet"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "ID of the created private subnet"
}

output "data_subnet_ids" {
  value       = aws_subnet.data_subnet[*].id
  description = "ID of the created data tier private subnets"
}