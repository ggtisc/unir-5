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