resource "aws_instance" "name" {
  ami           = var.ami_id
  instance_type = var.instance_ty
  tags = {
    Name = var.instance_name
  }
  
}