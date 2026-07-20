data "aws_subnet" "sub" {
  filter {
    name = "tag:Name"
    values = ["my-subnet"]
  }
}

data "aws_security_group" "sg" {
    filter {
      name = "tag:Name"
      values = ["my-sg"]
    }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}
resource "aws_instance" "name" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.sub.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  tags = {
    Name = "sam-server-1"
  }

}