variable "region" {
  description =  "The default region of the system"
  default = "eu-west-1"
}

variable "cidr" {
  description = "Default CIDR for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet of VPC"
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_database_subnets" {
  description = "Private Database subnets of VPC"
  type = list
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_intra_subnets" {
  description = "Private Backend intra subnets of VPC"
  type = list
  default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type    = list
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "vpc_name" {
  description = "Name"
  type = string
  default = "demonet"  
}

variable "tag_monitor" {
  description = "Monitor"
  type = string
  default = "on"
}

variable "tag_logging" {
  description = "Logging"
  type = string
  default = "on"
}

variable "uuid_namespace" {
  description = "UUID Namespace DNS"
  type = string
  default = "dns"
}

variable "uuid_name" {
  description = "DNS name"
  type = string
  default = "brandonsoftwarelabs.com"
}

  
  
