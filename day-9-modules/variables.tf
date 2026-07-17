variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = ""
  
}

variable "instance_ty" {
  description = "The type of instance to create"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = ""
  
}