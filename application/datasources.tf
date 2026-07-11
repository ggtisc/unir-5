# Terraform AWS Data Sources Configuration

data "terraform_remote_state" "networking" {
  backend = "local" # Could be an S3 bucket if it was on it
  config = {
    path = "../networking/terraform.tfstate"
  }
}