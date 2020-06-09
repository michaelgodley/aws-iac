locals {
  vpc_count = 1
}

resource "aws_security_group" "this" {
  count = length(var.security_groups) > 0 ? length(var.security_groups) : 0
  name = lookup(element(var.security_groups, count.index), "name", "name")
  description = lookup(element(var.security_groups, count.index), "description", "description")
  vpc_id = var.vpc_id

  # inbound internet access
  dynamic "ingress" {
    for_each = var.security_groups[count.index].ingress_rules
    content {
      from_port = lookup(ingress.value, "from_port", "from_port")
      to_port = lookup(ingress.value, "to_port", "to_port")
      protocol = lookup(ingress.value, "protocol", "protocol")
      cidr_blocks = lookup(ingress.value, "cidr_blocks", "cidr_blocks")
      description = lookup(ingress.value, "description", "description")
    }
  }
  
  # outbound internet access
  dynamic "egress" {
    for_each = var.security_groups[count.index].egress_rules
    content {
      from_port = lookup(egress.value, "from_port", "from_port")
      to_port = lookup(egress.value, "to_port", "to_port")
      protocol = lookup(egress.value, "protocol", "protocol")
      cidr_blocks = lookup(egress.value, "cidr_blocks", "cidr_blocks")
      description = lookup(egress.value, "description", "description")
    }
  }

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "sg", count.index+1])
    },
    var.tags,
    var.vpc_tags,
  )  
}
