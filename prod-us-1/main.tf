provider "aws" {
  profile = "default"
  region  = var.region
}

locals {
  identifier = uuidv5(var.uuid_namespace, var.uuid_name)

  securitygroups = [
    {
      name = "SG Public"
      description = "My VPC SG Public"
      ingress_rules = [
        {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "VPC"
        },
        {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["192.168.1.10/32"]
          description = "WFH"
        },
        {
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTP"
        },
        {
          from_port = 443
          to_port = 443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTPS"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "All Ports"
        }
      ]
    },
    {
      name = "SG Private"
      description = "My VPC SG Private"
      ingress_rules = [
        {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "VPC"
        },
        {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["192.168.1.10/32"]
          description = "WFH"
        },
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "All Ports"          
        }
      ]      
    },
    {
      name = "SG Dev"
      description = "My VPC SG Dev"
      ingress_rules = [
        {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "VPC"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "All Ports"          
        }
      ]      
    }
  ]
}

module "vpc" {
  source = "../modules/vpc"

  vpc_name = var.vpc_name
  cidr = var.cidr
  public_subnets = var.public_subnets
  private_database_subnets = var.private_database_subnets
  private_intra_subnets = var.private_intra_subnets
  azs = var.azs
  vpc_tags = {
    Identifier = local.identifier
  }
}

module "securitygroups" {
  source = "../modules/securitygroups"

  vpc_id = module.vpc.vpc_id
  vpc_name = var.vpc_name  
  security_groups = local.securitygroups
  vpc_tags = {
    Identifier = local.identifier
  }  
}
  

