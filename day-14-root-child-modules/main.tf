terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.common_tags
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id           = module.network.vpc_id
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  allowed_http_cidr = var.allowed_http_cidr
  sg_name           = "web-server-sg"
  tags              = var.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  ami_id             = var.instance_ami
  instance_type      = var.instance_type
  subnet_id          = module.network.public_subnet_ids[0]
  security_group_ids = [module.security_group.sg_id]
  key_name           = var.instance_key_name
  instance_name      = "web-server-instance"
  tags               = var.common_tags
}

output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID created by the network module."
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Public subnet IDs created by the network module."
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Private subnet IDs created by the network module."
}

output "security_group_id" {
  value       = module.security_group.sg_id
  description = "Security group ID created by the security group module."
}

output "ec2_public_ip" {
  value       = module.ec2.instance_public_ip
  description = "Public IP of the EC2 instance."
}
