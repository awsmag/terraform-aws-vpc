
variable "region" {}

variable "cidr" {}

variable "publicCidr" {}

variable "privateCidr" {}

variable "namespace" {
  default = "tf-generated-vpc"
}