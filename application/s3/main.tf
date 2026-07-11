# S3 module resources

# Random suffix for bucket name uniqueness
# S3 bucket names must be globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# AWS ELB Service Account for current region
# Used to grant ALB permissions to write access logs to S3
data "aws_elb_service_account" "main" {
}

# Application S3 bucket for assets and ALB access logs
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.bucket_base_name}-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name = "app-bucket-iaas-1"
  }
}

# Block all public access to the S3 bucket
# Ensures the bucket is private and not accessible to the public
resource "aws_s3_bucket_public_access_block" "app_bucket_pab" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy to allow ALB to write access logs
# Grants the ELB service account permission to put objects in the bucket
resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowELBPutObject"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.main.arn
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.app_bucket.id}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.app_bucket_pab]
}
