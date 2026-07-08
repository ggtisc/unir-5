# VPC Endpoint (Gateway) - generic reusable module

resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids
  tags              = var.vpc_endpoint_tags
}

# Associate the gateway endpoint with provided route tables
resource "aws_vpc_endpoint_route_table_association" "association" {
  count           = length(var.route_table_ids)
  route_table_id  = var.route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint.id
}
