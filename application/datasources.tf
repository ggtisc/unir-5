# Terraform AWS Data Sources Configuration

data "terraform_remote_state" "networking" {
  backend = "local" # Could be an S3 bucket if it was on it
  config = {
    path = "../networking/terraform.tfstate"
  }
}

# data "aws_ami" "latest_golden_image" {
#   most_recent = true
#   owners      = ["self"] # Solo busca AMIs creadas en tu cuenta

#   filter {
#     name   = "name"
#     values = ["golden-image-nginx-*"] # El patrón de nombre que usa tu Packer
#   }
# }