# Root Module: day-14-root-child-modules

This root module orchestrates three child modules:

1. `modules/network`
2. `modules/security-group`
3. `modules/ec2`

## Purpose

- `modules/network` creates the VPC, public/private subnets, Internet Gateway, and a public route table.
- `modules/security-group` creates an EC2 security group for SSH and HTTP access.
- `modules/ec2` launches an EC2 instance into a public subnet and attaches the security group.

## How values flow

### Root variables

Root variables are defined in `variables.tf` and populated in `terraform.tfvars`.

Example root variables:
- `vpc_cidr`
- `public_subnet_cidrs`
- `private_subnet_cidrs`
- `availability_zones`
- `allowed_ssh_cidr`
- `allowed_http_cidr`
- `instance_ami`
- `instance_type`
- `instance_key_name`
- `common_tags`

### Network module input

`main.tf` in the root module passes these values into `modules/network`:

```hcl
module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.common_tags
}
```

### Security group module input

The security group module receives the VPC ID output from the network module:

```hcl
module "security_group" {
  source = "./modules/security-group"

  vpc_id            = module.network.vpc_id
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  allowed_http_cidr = var.allowed_http_cidr
  sg_name           = "web-server-sg"
  tags              = var.common_tags
}
```

### EC2 module input

The EC2 module receives the first public subnet and security group ID:

```hcl
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
```

## Validation

The root module has been validated successfully with `terraform validate`.

## Usage

Run these commands from `terraform/day-14-root-child-modules`:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```
