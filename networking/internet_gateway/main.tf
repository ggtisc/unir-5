# Gateway resource

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.internet_gateway_vpc_id
  tags = merge(var.internet_gateway_tags, {
    Name = "igw-iaas-1"
  })
}