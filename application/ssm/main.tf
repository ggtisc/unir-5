resource "aws_ssm_parameter" "ami_id" {
  name  = "/app/frontend/ami_id"
  type  = "String"
  value = var.initial_ami_id

  lifecycle {
    ignore_changes = [value]
  }
}