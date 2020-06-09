variable "vpc_name" {
  description = "Name to be used on resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for SG"
  type = string
}

variable "security_groups" {
  description = "Full List of Security Groups for the VPC"
  type = list
  default = []
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


  
