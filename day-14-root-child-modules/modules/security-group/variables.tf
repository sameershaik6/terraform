variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access SSH."
  type        = string
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed to access HTTP."
  type        = string
}

variable "sg_name" {
  description = "Name to assign to the security group."
  type        = string
}

variable "tags" {
  description = "Tags applied to the security group."
  type        = map(string)
  default     = {}
}
