# Gateway resource

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.internet_gateway_vpc_id
  tags   = var.internet_gateway_tags
}