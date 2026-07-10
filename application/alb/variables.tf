# ALB module variables

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "access_logs_bucket_id" {
  description = "S3 bucket ID for ALB access logs"
  type        = string
}
