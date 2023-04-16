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

resource "aws_vpc" "a4l-vpc1" {
  cidr_block                       = local.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
}

# resource "aws_subnet" "a4l-vpc1-sn" {
#   vpc_id     = aws_vpc.a4l-vpc1.id
#   availability_zone = 
#   cidr_block = 
#   assign_ipv6_address_on_creation = true

#   ipv6_cidr_block

# }
