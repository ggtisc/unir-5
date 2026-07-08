# Security Group module variables

variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "alb_ports" {
  description = "List of ports to allow for the ALB security group"
  type        = list(number)
  default     = [80, 443]
}

variable "app_ports" {
  description = "List of application ports to allow from the ALB security group"
  type        = list(number)
  default     = [80, 3000, 4200]
}