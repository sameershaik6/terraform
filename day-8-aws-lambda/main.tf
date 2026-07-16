# This is the main.tf file for the AWS Lambda function deployment using Terraform.

#create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  
}

#create a policy attachment to attach the AWSLambdaBasicExecutionRole default policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" 
}

#this data block creates a zip archive of the Lambda function code.
# It takes the source file (lambda_function.py) and creates a zip file (lambda_function.zip)
# in the same module directory. This zip file will be used as the deployment package for the Lambda function.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}
#create an S3 bucket to store the Lambda function code
resource "aws_s3_bucket" "lambda_code" {
  bucket = "my-saam-lambda-code-12001"
}

#create an S3 object to upload the Lambda function code to the S3 bucket
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_code.id
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}

#create the Lambda function resource. This resource defines the Lambda function, including its name, IAM role, runtime, handler, timeout, memory size, and the S3 bucket and key where the deployment package is stored.
resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    runtime       = "python3.8"
    handler       = "lambda_function.lambda_handler"
    #filename      = "lambda_function.zip" # Ensure this zip file is created and contains your Lambda function code
    timeout       = 400
    memory_size   = 128

   # source_code_hash = filebase64sha256("lambda_function.zip") # This ensures that the Lambda function is updated when the zip file changes
    #source code hash is used to detect changes in the source code and trigger an update to the Lambda function when the zip file changes.
    s3_bucket     = aws_s3_bucket.lambda_code.id
    s3_key        = aws_s3_object.lambda_zip.key
}

resource "aws_cloudwatch_event_rule" "daily_lambda"{
    name = "daily_lambda"
    description = "Trigger Lambda function daily"
    schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.daily_lambda.name
    target_id = "my_lambda_function"
    arn = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.daily_lambda.arn
}


# lambda_function.py
#        │
#        ▼
# Terraform archive_file creates ZIP locally
#        │
#        ▼
# Terraform uploads ZIP to your existing S3 bucket
#        │
#        ▼
# Terraform tells Lambda: use this bucket + ZIP key
#        │
#        ▼
# Lambda deploys the code and runs lambda_handler()

# You keep deployment code in S3 rather than relying on a manually managed local ZIP.
# Terraform makes deployment repeatable: anyone with the configuration and credentials
# can deploy the same infrastructure.
# Editing the Python file and running terraform apply updates the deployed Lambda automatically.


# Deploy an AWS Lambda function using Terraform, where the Lambda deployment package (ZIP file) is automatically created, uploaded to an S3 bucket, and used to create the Lambda function.    

# *key terraform resources used-- 
 
# archive_file   ----	Creates the Lambda ZIP package
# aws_s3_bucket----- Creates the S3 bucket
# aws_s3_object -----	Uploads the ZIP file to S3
# aws_iam_role ----	Creates the Lambda execution role
# aws_iam_role_policy_attachment-----	Attaches the execution policy
# aws_lambda_function	------ Creates the Lambda function from the S3 deployment package
# aws_cloudwatch_event_rule	Creates the daily EventBridge schedule
# aws_lambda_permission	Allows EventBridge to invoke Lambda
# aws_cloudwatch_event_target	Connects the EventBridge rule to the Lambda function

# *Outcome*
# --Automated the complete AWS Lambda deployment using Terraform.
# --Eliminated manual ZIP creation and manual S3 uploads.
# ---Managed all infrastructure as code (IaC), making deployments repeatable, version-controlled, and easy to maintain.
# Automated daily Lambda execution using Amazon EventBridge without manual intervention.


# Terraform Apply
#       │
#       
# Package Lambda Source Code
#       │
#       
# Create Amazon S3 Bucket
#       │
#       
# Upload Lambda ZIP to S3
#       │
#       
# Create IAM Role
#       │
#       
# Attach Lambda Execution Policy
#       │
#       
# Create AWS Lambda Function
#       │
#       
# Create Amazon EventBridge Schedule
#       │
#       
# Grant EventBridge Permission to Invoke Lambda
#       │
#       
# Associate EventBridge Rule with Lambda
#       │
#       
# Lambda Executes Automatically Every Day at 00:00 UTC