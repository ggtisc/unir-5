variable "ssm_parameter_name" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance type for the launch template"
  type        = string
  default     = "t3.medium"
}

variable "ec2_sg_id" {
  description = "Security group ID to attach to the EC2 instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for the EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group to register the instances with"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in the autoscaling group"
  type        = number
  default     = 2
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the instances will be launched"
  type        = list(string)
}
