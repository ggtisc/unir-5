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

module "ssm" {
  source         = "./ssm"
  initial_ami_id = "ami-088b41ffb0933423f"
}

# ASG Module
module "asg" {
  source                    = "./asg"
  private_subnet_ids        = data.terraform_remote_state.networking.outputs.private_subnets
  ec2_sg_id                 = module.sg.ec2_sg_id
  iam_instance_profile_name = module.iam.instance_profile_name
  target_group_arn          = module.alb.target_group_arn
  instance_type             = "t3.micro"
  ssm_parameter_name = module.ssm.parameter_name
}

# WAF Module
module "waf" {
  source  = "./waf"
  alb_arn = module.alb.alb_arn
}

# ACL Module
module "acl" {
  source             = "./acl"
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.networking.outputs.public_subnets
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets
}