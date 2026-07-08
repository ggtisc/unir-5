# Route Table resource

# Route table
resource "aws_route_table" "route_table" {
  vpc_id = var.route_table_vpc_id
  tags   = var.route_table_tags
}

# Public route to Internet Gateway
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.route_table_internet_gateway_id
}

# Route table association with public subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.route_table_public_subnet_ids)
  subnet_id      = var.route_table_public_subnet_ids[count.index]
  route_table_id = aws_route_table.route_table.id
}