# S3 module outputs

output "bucket_id" {
  value       = aws_s3_bucket.app_bucket.id
  description = "ID of the S3 bucket for application assets and ALB logs"
}

output "bucket_arn" {
  value       = aws_s3_bucket.app_bucket.arn
  description = "ARN of the S3 bucket for application assets and ALB logs"
}
