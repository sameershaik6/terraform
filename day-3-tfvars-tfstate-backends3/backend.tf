terraform {
  backend "s3" {
    bucket = "bucket-name"
    key = "terraform.tfstate"
   region = "us-east-1" 
  }
}

#State Storage
#The S3 backend stores state data in an S3 object at the path set by the key parameter
#in the S3 bucket indicated by the bucket parameter. Using the example shown above,
#the state would be stored at the path path/to/my/key in the bucket mybucket.