# locals is used to store reusable values or lists.
# Here we create a list of rules, where each rule has a port and its own CIDR value.
locals {
  ingress_rules = [
    { port = 80, cidr_blocks = ["10.0.0.0/24"] },
    { port = 443, cidr_blocks = ["192.168.1.0/24"] },
    { port = 22, cidr_blocks = ["203.0.113.0/24"] },
    { port = 3000, cidr_blocks = ["198.51.100.0/24"] },
    { port = 8081, cidr_blocks = ["192.0.2.0/24"] },
    { port = 9000, cidr_blocks = ["10.10.0.0/24"] }
  ]
}

resource "aws_security_group" "name" {
  name        = "devops-project-sam"
  description = "Allow TLS inbound traffic"

  # This uses a for expression to loop through each item in local.ingress_rules.
  # For every rule, Terraform creates one ingress block with its own port and CIDR.
  ingress = [
    for rule in local.ingress_rules : {
      description      = "inbound rules"
      from_port        = rule.port
      to_port          = rule.port
      protocol         = "tcp"
      cidr_blocks      = rule.cidr_blocks
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-sam"
  }
}
