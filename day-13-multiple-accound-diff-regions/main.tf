# Each resource uses a different provider alias,
# so one bucket is created in the dev account and one in the test account.

resource "aws_s3_bucket" "dev_bucket" {
  bucket   = "buck-sam-1010"
  provider = aws.dev-account
}



resource "aws_s3_bucket" "test_bucket" {
  bucket   = "buck-sam-2101"
  provider = aws.test-account
}

# Why this is useful:
# - You can create resources in different AWS accounts from the same Terraform code.
# - Each account can have its own region and credentials.
# - This is helpful for dev/test/prod separation.

# Important note:
# - S3 bucket names must be globally unique across all AWS accounts.
# - Make sure the bucket names you use are not already taken.