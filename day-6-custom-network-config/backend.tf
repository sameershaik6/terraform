terraform {
    backend "s3" {
        bucket = "terraform-state-file-bucket-123"
        key    = "terraform.tfstate"
        region = "us-east-1"
        use_lockfile = true   #created lock file to avoid concurrent modification of state file
    }
  
}


#use_lockfile = true ##supports terrafrom latest version >=1.10
#dynamodb_table = "terraform-state-locking"  #if terrafrom version <1.10 use below code