# Route Table resource

# Public Route Table
resource "aws_route_table" "route_table" {
  vpc_id = var.route_table_vpc_id
  tags = merge(var.route_table_tags, {
    Name = "public-route-table-iaas-1"
    Tier = "Public"
  })
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

# Private Route Tables (one for each private subnet)
# These tables are isolated with no internet gateway routes
resource "aws_route_table" "private_route_table" {
  count  = 3 # Create exactly 3 private route tables
  vpc_id = var.route_table_vpc_id
  tags = merge(var.route_table_tags, {
    Name = "private-route-table-iaas-${count.index + 1}"
    Tier = "Private"
  })
}

# Route table association with private subnets
# Associates each private route table exclusively with its corresponding private subnet
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.route_table_private_subnet_ids)
  subnet_id      = var.route_table_private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table[count.index].id
}