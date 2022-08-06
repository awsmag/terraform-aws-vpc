
variable "region" {
  description = "The region in which you would like to create a VPC"
  nullable = false
}

variable "cidr_block" {
  description = "the primary CIDR block for the VPC"
  nullable = false
}

variable "public_subnet_cidr" {
  description = "The list of CIDR blocks for public subnet"
  type = list(string)
  nullable = false
}

variable "private_subnet_cidr" {
  description = "The list of CIDR blocks for private subnet"
  type = list(string)
  nullable = false
}

variable "namespace" {
  default = "tf-generated-vpc"
  nullable = false
}