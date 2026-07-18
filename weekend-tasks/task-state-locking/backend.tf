terraform {
  backend "s3" {
    bucket = "my-terraform-state-locking-bucket-10101"
    key    = "terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true   #created  native s3 locking file to avoid concurrent modification of state file
    #dynamodb_table = "terraform-locks" #dynamodb table to avoid concurrent modification of state file
    encrypt = true
  }
}

#to lock the state file in s3 bucket we can use either of the two methods mentioned above.
#s3 locking file is a native feature of s3 bucket and is available in terraform version >=1.10
#dynamodb table locking is a feature of terraform and is available in terraform version <1.10
