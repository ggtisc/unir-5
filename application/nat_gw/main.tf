# NAT Gateway module resources

# Elastic IP addresses for NAT Gateways
# Creates one EIP for each public subnet
resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"

  tags = {
    Name = "nat-eip-iaas-${count.index + 1}"
  }

  depends_on = []
}

# NAT Gateways for internet egress from private subnets
# Creates one NAT Gateway in each public subnet
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name = "nat-gw-iaas-${count.index + 1}"
  }

  depends_on = [aws_eip.nat_eip]
}

# Routes from private route tables to NAT Gateways
# Associates each private route table with its corresponding NAT Gateway
resource "aws_route" "private_nat_route" {
  count                  = length(var.private_route_table_ids)
  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id

  depends_on = [aws_nat_gateway.nat_gw]
}
