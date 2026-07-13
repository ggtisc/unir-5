# Terraform AWS Data Sources Configuration

data "terraform_remote_state" "networking" {
  backend = "local" # Could be an S3 bucket if it was on it
  
  config = {
    path = "../networking/terraform.tfstate"
  }
}

data "aws_ami_ids" "app_ami" {
  owners         = ["self"]
  sort_ascending = false

  filter {
    name   = "name"
    values = ["mean-app-docker-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}