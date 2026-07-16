resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "demo" {

  function_name = "demo"

  role = aws_iam_role.lambda_role.arn

  filename = "lambda.zip"
  handler  = "lambda_function.lambda_handler"
  runtime  = "python3.12"

#Without depends_on, Terraform may create the Lambda before AWS finishes attaching the policy.
  depends_on = [ 
    aws_iam_role_policy_attachment.basic
  ]
}


# Don't use depends_on if Terraform can infer the dependency through a resource reference.
# Use depends_on when there is no direct reference but the creation order still matters.

# For AWS, the most common real-world cases where depends_on is helpful are:

# Lambda waiting for IAM policy attachment.
# S3 bucket notifications waiting for Lambda permissions.
# API Gateway deployments waiting for integrations.
# Resources that rely on IAM permission propagation, where AWS is eventually consistent.

# Using depends_on only when necessary keeps your Terraform configuration cleaner and lets
#  Terraform build the dependency graph automatically whenever possible.