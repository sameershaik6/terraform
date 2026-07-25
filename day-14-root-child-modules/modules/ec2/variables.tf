variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched."
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs attached to the EC2 instance."
  type        = list(string)
}

variable "key_name" {
  description = "Optional key pair name for SSH access."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name tag to assign to the EC2 instance."
  type        = string
}

variable "tags" {
  description = "Tags applied to the EC2 instance."
  type        = map(string)
  default     = {}
}
