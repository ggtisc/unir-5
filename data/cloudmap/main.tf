resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "internal"
  vpc         = var.vpc_id
  description = "Private namespace for service discovery"
}

resource "aws_service_discovery_service" "mongo" {
  name        = "mongo"
  description = "MongoDB service"

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.internal.id
    routing_policy = "MULTIVALUE"

    dns_records {
      type = "A"
      ttl  = 60
    }
  }

  health_check_custom_config {}
}
