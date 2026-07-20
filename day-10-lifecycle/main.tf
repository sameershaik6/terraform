
resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"    
  instance_type = "t3.micro"
  tags = {
    Name = "sam-server-1"
  }
  lifecycle {
    ignore_changes = [ tags ]    #ignore the changes of tags done local or console
    create_before_destroy = true
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "sam-buk-2"

  lifecycle {
    create_before_destroy = true  #by default terraform first destroy then create resources this will first create then destroy
    prevent_destroy = true   #this will prevent terraform to destroy resources
  }
 
}
