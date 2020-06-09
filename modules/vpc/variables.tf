variable "vpc_name" {
  description = "Name to be used on resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "Primary CIDR for VPC"
  type = string
  default = "0.0.0.0/0"
}

variable "secondary_cidr_blocks" {
  description = "Secondary CIDR Blocks for the VPC"
  type = list
  default = []
}

variable "public_subnets" {
  description = "Public subnets of VPC"
  type = list
  default = []
}

variable "private_database_subnets" {
  description = "Private Database subnets of VPC"
  type = list
  default = []
}

variable "private_intra_subnets" {
  description = "Private Backend intra subnets of VPC"
  type = list
  default = []
}

variable "azs" {
  description = "Availability Zones"
  type    = list
  default = []
}

variable "enable_ipv6" {
  description = "Enable AWS provided IP6 block"
  type = bool
  default = false
}

variable "enable_dns_hostnames" {
  description = "Enable DNS Hostnames"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "Enable DNS Support"
  type = bool
  default = true
}

variable "instance_tenancy" {
  description = "Instance Tenancy of the CIDR "
  type = string
  default = "default"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

  
  
