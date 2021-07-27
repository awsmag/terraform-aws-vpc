
variable "region" {
  default = "eu-west-1"
}

variable "cidr" {
  default = "192.0.0.0/20"
}

variable "publicSubnetCIDR" {
  type = list(string)
  default = [ "192.0.1.0/24", "192.0.2.0/24", "192.0.3.0/24" ]
}

variable "privateSubnetCIDR" {
  type = list(string)
  default = [ "192.0.4.0/24", "192.0.5.0/24", "192.0.6.0/24" ]
}

variable "namespace" {
  default = "tf-generated-vpc"
}