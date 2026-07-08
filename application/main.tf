# Main Modules

module "sg" {
  source = "./sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}

