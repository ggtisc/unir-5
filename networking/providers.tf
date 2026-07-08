# Terraform AWS Provider Configuration

provider "aws" {
  profile = "terraform-unir"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}