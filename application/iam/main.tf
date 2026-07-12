# IAM Role for Application EC2 Instances

# Allows EC2 instances to assume this role on startup for native permission-based access
resource "aws_iam_role" "app_ec2_role" {
  name = "app-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name   = "app-ec2-role"
    Module = "iam"
  }
}

# AWS Managed Policy: Systems Manager Agent for secure access without SSH
# Provides capabilities for Session Manager and other SSM features
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# AWS Managed Policy: CloudWatch Agent Server for application and ALB monitoring
# Enables EC2 instances to send logs and metrics to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Custom Enterprise Policy: S3 and Secrets Manager access for application runtime
# Allows the application to retrieve secrets and objects from managed storage
# Permits backend services to dynamically obtain MongoDB credentials
resource "aws_iam_policy" "app_s3_secrets_policy" {
  name        = "app-s3-secrets-policy"
  description = "Custom policy for S3 and Secrets Manager access from EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Sid    = "SecretsManagerAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      },
      {
        Sid    = "ParameterStoreAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name   = "app-s3-secrets-policy"
    Module = "iam"
  }
}

# Attach custom policy to the IAM role
resource "aws_iam_role_policy_attachment" "app_s3_secrets_attachment" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = aws_iam_policy.app_s3_secrets_policy.arn
}

# Instance Profile that wraps the IAM role
# Required for EC2 instances to use the IAM role at launch time
resource "aws_iam_instance_profile" "app_ec2_instance_profile" {
  name = "app-ec2-instance-profile"
  role = aws_iam_role.app_ec2_role.name

  tags = {
    Name   = "app-ec2-instance-profile"
    Module = "iam"
  }
}

