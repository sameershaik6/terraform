variable "cidr_block" {
  description = "my vpc cidr value"
  type = string
  default = ""
}

variable "subnet_cidr_block" {
  description = "my subnet cidr value"
  type = string
  default = ""
}

variable "tag_vpc" {
  description = "my tags value"
  type = string
  default = ""
}

variable "tag_subnet" {
  description = "my tags value"
  type = string
  default = ""
}