# Creates a security group in the VPC created by module.network.
# The VPC ID is passed from the root module using module.network.vpc_id.
resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group for EC2 web server."
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow SSH from the allowed SSH CIDR."
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_ssh_cidr]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "Allow HTTP from the internet."
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_http_cidr]
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "Allow all outbound traffic."
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    Name = var.sg_name
  })
}
