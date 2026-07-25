variable "aws_region" {
  description = "AWS region for provider configuration."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones for subnet placement."
  type        = list(string)
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access SSH."
  type        = string
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed to access HTTP."
  type        = string
}

variable "instance_ami" {
  description = "AMI ID used to launch the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "instance_key_name" {
  description = "SSH key pair name for the EC2 instance."
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags added to all created resources."
  type        = map(string)
  default = {
    Project     = "terraform-root-child-modules"
    Environment = "dev"
  }
}
