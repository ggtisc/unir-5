# Main Modules

# SG Module
module "sg" {
  source = "./sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}

#IAM Module
module "iam" {
  source = "./iam"
}

# NAT Gateway Module
# Provides internet egress for private subnets
module "nat_gw" {
  source                  = "./nat_gw"
  public_subnet_ids       = data.terraform_remote_state.networking.outputs.public_subnets
  private_route_table_ids = data.terraform_remote_state.networking.outputs.private_route_table_ids
  depends_on              = [module.sg]
}