# Launches an EC2 instance into the public subnet created by module.network.
# The security group ID is passed from module.security_group.sg_id.
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}
