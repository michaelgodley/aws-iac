locals {
  vpc_count = 1

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.this.*.id,
      [""],
      ),
    0,
  )
}

#################
# VPC
#################
resource "aws_vpc" "this" {
  count = local.vpc_count
  cidr_block = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  instance_tenancy = var.instance_tenancy
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count])
    },
    var.tags,
    var.vpc_tags,
  )
}

# Create Secondary CIDR Blocks if defined
resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0
  vpc_id = aws_vpc.this[0].id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

#################
# IGW
#################
resource "aws_internet_gateway" "igw" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "igw"])
    },
    var.tags,
    var.vpc_tags,
  )
}

#################
# Public Routes
#################
resource "aws_route_table" "public" {
  # count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "public-route", "1"])
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_route" "public_igw" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}

#################
# Private Routes
#################
resource "aws_route_table" "private" {
  #count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "private-route", "1"])
    },
    var.tags,
    var.vpc_tags,
  )
}

#################
# Public Subnets
#################
locals {
  azs_count = length(var.azs)
}

resource "aws_subnet" "public" {
  count =  length(var.public_subnets)
  vpc_id = local.vpc_id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index%local.azs_count)

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "public-subnet", count.index+1])
    },
    var.tags,
    var.vpc_tags,
  )
}

#################
# NAT Gateway
#################
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "eip-nat"])
    },
    var.tags,
    var.vpc_tags,
  )  
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "nat-gw"])
    },
    var.tags,
    var.vpc_tags,
  )  

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "ngw" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id

  timeouts {
    create = "5m"
  }
}

#################
# Private Subnets
#################
resource "aws_subnet" "database_subnets" {
  count =  length(var.private_database_subnets)
  vpc_id = local.vpc_id
  cidr_block = element(var.private_database_subnets, count.index)
  availability_zone = element(var.azs, count.index%local.azs_count)

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "private-db-subnet", count.index+1])
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_subnet" "intra_subnets" {
  count =  length(var.private_intra_subnets)
  vpc_id = local.vpc_id
  cidr_block = element(var.private_intra_subnets, count.index)
  availability_zone = element(var.azs, count.index%local.azs_count)

  tags = merge(
    {
      Name = join("-", [var.vpc_name, "vpc", local.vpc_count, "private-intra-subnet", count.index+1])
    },
    var.tags,
    var.vpc_tags,
  )
}

#################
# Route Table Assoc
#################
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

locals {
  private_subnets = concat(aws_subnet.database_subnets[*].id, aws_subnet.intra_subnets[*].id)
}

resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)

  subnet_id = element(local.private_subnets, count.index)
  route_table_id = aws_route_table.private.id
}
