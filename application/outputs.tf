# Module Outputs

# SG Module Outputs
output "alb_sg_id" {
  value       = module.sg.alb_sg_id
  description = "ID of the ALB security group"
}

output "ec2_sg_id" {
  value       = module.sg.ec2_sg_id
  description = "ID of the EC2 security group"
}

# IAM Module Outputs
output "instance_profile_name" {
  value       = module.iam.instance_profile_name
  description = "Name of the IAM instance profile for EC2 instances"
}