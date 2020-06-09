output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr" {
  value = module.vpc.cidr
}

output "public_route_id" {
  value = module.vpc.public_route_id
}

output "private_route_id" {
  value = module.vpc.private_route_id
}

#output "sg_dev" {
#  value = module.securitygroups.sg_dev
#}

#output "subnet_ids" {
#  value = module.vpc.subnet_ids
#}
