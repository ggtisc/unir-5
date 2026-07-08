# Internet Gatway outputs

output "internet_gateway_id" {
  value       = aws_internet_gateway.internet_gateway.id
  description = "Internet Gateway ID"
}