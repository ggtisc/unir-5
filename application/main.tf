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
# module "nat_gw" {
#   source                  = "./nat_gw"
#   public_subnet_ids       = data.terraform_remote_state.networking.outputs.public_subnets
#   private_route_table_ids = data.terraform_remote_state.networking.outputs.private_route_table_ids
#   depends_on              = [module.sg]
# }

# S3 Module
# Storage for application assets and ALB access logs
module "s3" {
  source            = "./s3"
  bucket_base_name  = "app-bucket-iaas"
}

# ALB Module
# Application Load Balancer for distributing traffic to EC2 instances
module "alb" {
  source                 = "./alb"
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet_ids      = data.terraform_remote_state.networking.outputs.public_subnets
  alb_sg_id              = module.sg.alb_sg_id
  access_logs_bucket_id  = module.s3.bucket_id
  depends_on             = [module.s3]
}