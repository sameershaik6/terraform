resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_s3_bucket" "my_bucket"{
 bucket = "my-terraform-state-locking-bucket-10101"
}