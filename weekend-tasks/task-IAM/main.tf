#this main.tf has IAM resources

#creation of iam user
resource "aws_iam_user" "dev" {
  name = "user-2"

tags = {
  Environment = "Dev"
  ManagedBy = "Terraform"
}
}

#creation login cred for iam user
resource "aws_iam_user_login_profile" "name" {
  user = aws_iam_user.dev.name
  password_reset_required = true
}


#creation of cli access key and secret keys for iam user
resource "aws_iam_access_key" "cli" {
  user = aws_iam_user.dev.name
}

#creation of custom policy for user
resource "aws_iam_policy" "s3_read_only_custom" {
  name = "S3ReadPolicy"
  description = "Allow read access to s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

#creation of an IAM group for developers
resource "aws_iam_group" "dev_group" {
  name = "dev-group"
}

#add the user to the IAM group
resource "aws_iam_user_group_membership" "dev_user_membership" {
  user   = aws_iam_user.dev.name
  groups = [aws_iam_group.dev_group.name]
}

#attach managed policy to the group
resource "aws_iam_group_policy_attachment" "readonly_group" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#attach custom S3 read policy to the group
resource "aws_iam_group_policy_attachment" "custompolicy_group" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.s3_read_only_custom.arn
}

#creation of policy attachments to user
resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#creation of policy attachments to users
resource "aws_iam_user_policy_attachment" "custompolicy" {
  user       = aws_iam_user.dev.name
  policy_arn = aws_iam_policy.s3_read_only_custom.arn
}

#creation of IAM role
resource "aws_iam_role" "ec2_full_access" {
  name = "Ec2FullAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        AWS = aws_iam_user.dev.arn
      }
    }]
  })
}

#creation of policy attachments to role
resource "aws_iam_role_policy_attachment" "ec2_full_access_attach" {
  role       = aws_iam_role.ec2_full_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

#creation of policy so user can assume ec2 full access role
resource "aws_iam_policy" "assume_ec2_full_access_role" {
  name        = "AssumeEc2FullAccessRole"
  description = "Allow user to assume the EC2 full access role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Resource = aws_iam_role.ec2_full_access.arn
    }]
  })
}

#attaching policy to user
resource "aws_iam_user_policy_attachment" "assume_role" {
  user       = aws_iam_user.dev.name
  policy_arn = aws_iam_policy.assume_ec2_full_access_role.arn
}



#This creates one attachment for each policy automatically.

# resource "aws_iam_user_policy_attachment" "policies" {
#   for_each = toset([
#     "arn:aws:iam::aws:policy/ReadOnlyAccess",
#     aws_iam_policy.s3_read_policy.arn
#   ])

#   user       = aws_iam_user.dev.name
#   policy_arn = each.value
# }
