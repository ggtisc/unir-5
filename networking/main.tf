# Main Modules

# VPC Module
module "vpc_00001" {
  source         = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_tags       = var.vpc_tags
}

# Subnet Module
module "subnets_00001" {
  source                    = "./subnet"
  subnet_vpc_id             = module.vpc_00001.vpc_id
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  data_subnet_cidr_block    = var.data_subnet_cidr_block
  subnet_availability_zone  = data.aws_availability_zones.available.names
  subnet_tags               = var.vpc_tags
}

# Internet Gateway Module
module "internet_gateway_00001" {
  source                  = "./internet_gateway"
  internet_gateway_vpc_id = module.vpc_00001.vpc_id
  internet_gateway_tags   = var.internet_gateway_tags
  depends_on              = [ module.vpc_00001 ]
}

# Route Table Module
module "route_table_00001" {
  source                          = "./route_table"
  route_table_vpc_id              = module.vpc_00001.vpc_id
  route_table_internet_gateway_id = module.internet_gateway_00001.internet_gateway_id
  route_table_public_subnet_ids   = module.subnets_00001.public_subnet_ids
  route_table_tags                = var.route_table_tags
  depends_on                      = [module.subnets_00001, module.internet_gateway_00001]
}

# VPC Endpoint Module (generic gateway endpoint)
module "vpc_endpoint" {
  source            = "./vpc_endpoint"
  vpc_id            = module.vpc_00001.vpc_id
  service_name      = var.vpc_endpoint_service_name
  route_table_ids   = [module.route_table_00001.route_table_id]
  vpc_endpoint_tags = var.vpc_tags
  depends_on        = [module.vpc_00001, module.route_table_00001]
}