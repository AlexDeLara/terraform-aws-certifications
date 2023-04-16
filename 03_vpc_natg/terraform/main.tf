terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "alex-de-lara"

    workspaces {
      name = "03_vpc_natg"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "a4l_vpc1" {
  cidr_block                       = local.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "a4l-vpc1"
  }

}

resource "aws_subnet" "a4l_vpc1_sn" {
  count                           = length(local.vpc_sn)
  vpc_id                          = aws_vpc.a4l_vpc1.id
  availability_zone               = local.vpc_sn[count.index].az
  cidr_block                      = cidrsubnet(aws_vpc.a4l_vpc1.cidr_block, 4, count.index)
  assign_ipv6_address_on_creation = true

  ipv6_cidr_block         = cidrsubnet(aws_vpc.a4l_vpc1.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch = local.vpc_sn[count.index].public

  tags = {
    Name = local.vpc_sn[count.index].name
  }

  depends_on = [aws_vpc.a4l_vpc1]

}

resource "aws_internet_gateway" "a4l_vpc1_igw" {
  vpc_id = aws_vpc.a4l_vpc1.id

  tags = {
    Name = "a4l-vpc1-igw"
  }

  depends_on = [aws_vpc.a4l_vpc1]
}

resource "aws_route_table" "a4l_vpc1_rt" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a4l_vpc1_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.a4l_vpc1_igw.id
  }

  tags = {
    Name = "a4l-vpc1-rt"
  }

  depends_on = [aws_vpc.a4l_vpc1, aws_internet_gateway.a4l_vpc1_igw]
}

# resource "aws_route_table_association" "a4l_vpc1_rt_association" {
#     for_each = toset([for sn in local.vpc_sn : sn.public ? sn.])
#   subnet_id      = aws_subnet.foo.id
#   route_table_id = aws_route_table.bar.id
# }
