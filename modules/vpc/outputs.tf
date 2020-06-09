output "vpc_id" {
  value = concat(aws_vpc.this.*.id, [""])[0]
}

output "cidr" {
  value = aws_vpc.this[0].cidr_block
}

output "public_route_id" {
  value = aws_route_table.public.id
}

output "private_route_id" {
  value = aws_route_table.private.id
}
