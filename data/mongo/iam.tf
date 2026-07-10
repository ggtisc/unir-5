resource "aws_iam_role" "mongo_role" {
  count = 3
  name  = "mongo-role-${count.index + 1}"

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
}

resource "aws_iam_instance_profile" "mongo_profile" {
  count = 3
  name  = "mongo-profile-${count.index + 1}"
  role  = aws_iam_role.mongo_role[count.index].name
}

resource "aws_iam_role_policy" "mongo_policy" {
  count = 3
  name  = "mongo-policy-${count.index + 1}"
  role  = aws_iam_role.mongo_role[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ec2:AttachVolume"
        Resource = "*"
        Condition = {
          StringEquals = {
            # Restringe el montaje estricta y únicamente a su disco correspondiente
            "aws:ResourceTag/MongoNode" = tostring(count.index + 1)
          }
        }
      }
    ]
  })
}