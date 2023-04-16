output "vpc1-ipv6-cidr" {
  value = aws_vpc.a4l-vpc1.ipv6_association_id
}

output "vpc1-ipv6-cidr2" {
  value = aws_vpc.a4l-vpc1.ipv6_cidr_block_network_border_group
}
