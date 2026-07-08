# Local Variables

locals { # Extract only your username from the long ARN returned by AWS instead of the entire ARN string (arn:aws:iam::123456789012:role/AdminRole) this just returns AdminRole
  current_iam_username = element(split("/", data.aws_caller_identity.terraform_account.arn), length(split("/", data.aws_caller_identity.terraform_account.arn)) - 1)
}