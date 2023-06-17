terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = local.base_context.profile
  region  = local.base_context.aws_region
}

/*
* Terraform code to create a VPC, Subnet and Security Group
*/

resource "aws_vpc" "sample_vpc" {
  cidr_block = local.env_config.vpc.cidr_block
  tags = {
    Name = local.env_config.stack_name
  }
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id     = aws_vpc.sample_vpc.id
  cidr_block = local.env_config.vpc_subnet.cidr_block
  tags = {
    Name = local.env_config.stack_name
  }
}

resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.sample_vpc.id

  ingress {
    from_port   = local.env_config.vpc_security_group.ingress_rules.from_port
    to_port     = local.env_config.vpc_security_group.ingress_rules.to_port
    protocol    = local.env_config.vpc_security_group.ingress_rules.protocol
    cidr_blocks = local.env_config.vpc_security_group.ingress_rules.cidr_blocks
  }
  tags = {
    Name = local.env_config.stack_name
  }
}