resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"
  user_data = file("user-data.sh")  #ccalling userdata file here
  associate_public_ip_address = true
  tags = {
    Name = "my-instance"
  }
}