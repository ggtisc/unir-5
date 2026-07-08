# Module Outputs

output "alb_sg_id" {
  value       = module.sg.alb_sg_id
  description = "ID of the ALB security group"
}

output "ec2_sg_id" {
  value       = module.sg.ec2_sg_id
  description = "ID of the EC2 security group"
}

