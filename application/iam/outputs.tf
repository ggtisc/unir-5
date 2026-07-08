# IAM module outputs

output "instance_profile_name" {
  value       = aws_iam_instance_profile.app_ec2_instance_profile.name
  description = "Name of the IAM instance profile for EC2 instances"
}

output "instance_profile_arn" {
  value       = aws_iam_instance_profile.app_ec2_instance_profile.arn
  description = "ARN of the IAM instance profile for EC2 instances"
}

output "app_ec2_role_name" {
  value       = aws_iam_role.app_ec2_role.name
  description = "Name of the IAM role for application EC2 instances"
}

output "app_ec2_role_arn" {
  value       = aws_iam_role.app_ec2_role.arn
  description = "ARN of the IAM role for application EC2 instances"
}