
#terraform import is used to bring existing infrastructure under Terraform management by
#importing it into the Terraform state.


resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"    
  instance_type = "t3.micro"
  tags = {
    Name = "sam-server-1"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "sam-buk-1"
}



