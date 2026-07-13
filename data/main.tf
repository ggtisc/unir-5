module "cloudmap" {
  source = "./cloudmap"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}

module "ssm" {
  source         = "./ssm"
  initial_ami_id = length(data.aws_ami_ids.mongo_ami.ids) > 0 ? data.aws_ami_ids.mongo_ami.ids[0] : var.fallback_mongo_ami_id
}

module "mongo" {
  source              = "./mongo"
  vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids  = data.terraform_remote_state.networking.outputs.private_subnets
  app_sg_id           = data.terraform_remote_state.application.outputs.ec2_sg_id
  instance_type       = "t3.micro"
  cloudmap_service_id = module.cloudmap.service_id
  ssm_parameter_name  = module.ssm.parameter_name
}