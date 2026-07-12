resource "aws_ssm_parameter" "ami_id" {
  name      = "/app/database/ami_id"
  type      = "String"
  data_type = "aws:ec2:image"
  value     = var.initial_ami_id

  lifecycle {
    ignore_changes = [value]
  }
}