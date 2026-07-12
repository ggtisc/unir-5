output "service_id" {
  value = aws_service_discovery_service.iaas_mongo.id
}

output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.iaas_dns.id
}