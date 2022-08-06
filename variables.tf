
variable "region" {}

variable "cidr_block" {}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "namespace" {
  default = "tf-generated-vpc"
}