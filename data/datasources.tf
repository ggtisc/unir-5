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