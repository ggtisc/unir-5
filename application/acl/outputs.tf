output "public_acl_id" {
  value       = aws_network_acl.public_acl.id
  description = "ID of the public network ACL"
}

output "private_acl_id" {
  value       = aws_network_acl.private_acl.id
  description = "ID of the private network ACL"
}
