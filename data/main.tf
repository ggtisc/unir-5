module "cloudmap" {
  source = "./cloudmap"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}

module "mongo" {
  source              = "./mongo"
  vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids  = data.terraform_remote_state.networking.outputs.private_subnets
  app_sg_id           = data.terraform_remote_state.application.outputs.ec2_sg_id
  instance_type       = "t3.micro"
  cloudmap_service_id = module.cloudmap.service_id
}