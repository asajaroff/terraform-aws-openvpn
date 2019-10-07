terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.23"
  region  = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source     = "github.com/asajaroff/terraform-aws-vpc.git?ref=v1.0"
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public" {
  count      = var.az_count
  vpc_id     = module.vpc.vpc_id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Main"
  }
}
