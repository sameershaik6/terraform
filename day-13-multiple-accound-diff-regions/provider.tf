# This file configures two AWS providers for two different accounts.
# Each provider uses its own profile, alias, and region.

provider "aws" {
  profile = "dev"
  alias   = "dev-account"
  region  = "us-east-1"
}

provider "aws" {
  profile = "test"
  alias   = "test-account"
  region  = "us-west-2"
}

# How it works:
# - Terraform uses the provider alias when a resource should be created in that account/region.
# - The profile name must match the AWS CLI profile configured on your machine.
# - The region decides where the resource will be created.
