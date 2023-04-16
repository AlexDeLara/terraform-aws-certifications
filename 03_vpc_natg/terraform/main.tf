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
}

resource "aws_subnet" "a4l_vpc1_sn" {
  count                           = length(local.vpc_sn)
  vpc_id                          = aws_vpc.a4l_vpc1.id
  availability_zone               = local.vpc_sn[count.index].az
  cidr_block                      = cidrsubnet(aws_vpc.a4l_vpc1.cidr_block, 4, count.index)
  assign_ipv6_address_on_creation = true

  ipv6_cidr_block = cidrsubnet(aws_vpc.a4l_vpc1.ipv6_cidr_block, 8, count.index)

  tags = {
    name = local.vpc_sn[count.index].name
  }

}

