# NAT Gateway module outputs

output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat_gw[*].id
  description = "IDs of the created NAT Gateways"
}

output "nat_eip_ids" {
  value       = aws_eip.nat_eip[*].id
  description = "IDs of the Elastic IPs allocated for NAT Gateways"
}

output "nat_eip_public_ips" {
  value       = aws_eip.nat_eip[*].public_ip
  description = "Public IP addresses of the Elastic IPs for NAT Gateways"
}
