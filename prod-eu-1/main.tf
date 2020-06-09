provider "aws" {
  profile = "default"
  region  = var.region
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
    Identifier = uuidv5(var.uuid_namespace, var.uuid_name)
  }
}

#module "securitygroups" {
#  source = "../modules/securitygroups"

#  vpc_tagname = var.vpc_tagname
#  vpc_id = module.vpc.vpc_id
#  id = var.id
#  uuid_name = var.uuid_name
#}
  

