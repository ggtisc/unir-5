# Subnet resource

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr_block)
  vpc_id                  = var.subnet_vpc_id
  cidr_block              = var.public_subnet_cidr_block[count.index]
  availability_zone       = element(var.subnet_availability_zone, count.index)
  map_public_ip_on_launch = true                                                # Assuming public subnets should map public IPs

  tags = merge(var.subnet_tags, {
    Name = "${var.subnet_tags["Name"]}-${substr(element(var.subnet_availability_zone, count.index), -1, 1)}-public-subnet"
    Tier = "Public"
  })
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidr_block)
  vpc_id                  = var.subnet_vpc_id
  cidr_block              = var.private_subnet_cidr_block[count.index]
  availability_zone       = element(var.subnet_availability_zone, count.index)
  map_public_ip_on_launch = false                                               # Assuming private subnets should not map public IPs

  tags = merge(var.subnet_tags, {
    Name = "${var.subnet_tags["Name"]}-${substr(element(var.subnet_availability_zone, count.index), -1, 1)}-private-subnet"
    Tier = "Private"
  })
}

# Data Tier Subnet (reusable, generic)
resource "aws_subnet" "data_subnet" {
  count                   = length(var.data_subnet_cidr_block)
  vpc_id                  = var.subnet_vpc_id
  cidr_block              = var.data_subnet_cidr_block[count.index]
  availability_zone       = element(var.subnet_availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.subnet_tags, {
    Name = "${var.subnet_tags["Name"]}-${substr(element(var.subnet_availability_zone, count.index), -1, 1)}-data-subnet"
    Tier = "Data"
  })
}