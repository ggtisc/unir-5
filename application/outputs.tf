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

# NAT Gateway Module Outputs
# output "nat_gateway_ids" {
#   value       = module.nat_gw.nat_gateway_ids
#   description = "IDs of the created NAT Gateways"
# }

# output "nat_eip_public_ips" {
#   value       = module.nat_gw.nat_eip_public_ips
#   description = "Public IP addresses of the Elastic IPs for NAT Gateways"
# }

# S3 Module Outputs
output "app_bucket_id" {
  value       = module.s3.bucket_id
  description = "Name of the S3 bucket generated with the random suffix"
}

output "app_bucket_arn" {
  value       = module.s3.bucket_arn
  description = "ARN of the S3 bucket"
}

# ALB Module Outputs
output "alb_arn" {
  value       = module.alb.alb_arn
  description = "ARN of the Application Load Balancer"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "target_group_arn" {
  value       = module.alb.target_group_arn
  description = "ARN of the ALB target group"
}