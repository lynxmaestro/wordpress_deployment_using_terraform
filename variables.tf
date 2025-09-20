variable "main_network" {
  default = "172.20.0.0/16"
}

variable "project_name" {
  default = "zomato"
}

variable "project_env" {
  default = "prod"
}

variable "region" {
  default = "ap-south-1"
}

variable "access_key" {
  default = "*******"
}

variable "secret_key" {
  default = "************"
}

variable "ami_id" {
  default = "ami-0c4a668b99e68bbde"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_zone_name" {
  default = "jeethu.shop"
}

variable "private_zone_name" {
  default = "jeethu.local"
}

variable "enable_nat_gw" {
  type    = bool
  default = true
}
