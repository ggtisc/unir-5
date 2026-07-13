data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}

data "terraform_remote_state" "application" {
  backend = "local"

  config = {
    path = "../application/terraform.tfstate"
  }
}

data "aws_ami_ids" "mongo_ami" {
  owners = ["self"]

  filter {
    name   = "name"
    values = ["mean-mongodb-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  sort_ascending = false
}