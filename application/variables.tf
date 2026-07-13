variable "fallback_app_ami_id" {
  description = "AMI ID genérica de respaldo (Día 0) si Packer aún no ha creado la imagen"
  type        = string
  default     = "ami-088b41ffb0933423f"
}