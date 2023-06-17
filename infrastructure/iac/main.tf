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

/*
* Terraform code to create a Internet Gateway, NAT Gateway and Elastic IP (eip)
*/

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    Name = local.env_config.stack_name
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = local.env_config.stack_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.vpc_subnet.id
  tags = {
    Name = local.env_config.stack_name
  }
}


/*
* lambda code bucket and lambda code uploaded to bucket
*/

resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "lambda-code-bucket-5897867"
}

resource "aws_s3_object" "data_fetcher_lambda_code" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  key    = "data_fetcher_lambda_code.jar"
  source = "jars/data-fetcher-lambda-0.1.0-SNAPSHOT-standalone.jar"
}

/*
* Lambda role and lambda function
*/

resource "aws_iam_role" "data_fetcher_lambda_role" {
  name               = "data_fetcher_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_lambda_function" "data_fetcher_lambda" {
  function_name = "data_fetcher_lambda"
  handler       = "data_fetcher_lambda.lambda::handle"
  runtime       = "java11"
  memory_size   = local.env_config.lambda.memory_size
  timeout       = local.env_config.lambda.timeout
  role          = aws_iam_role.data_fetcher_lambda_role.arn

  s3_bucket = aws_s3_bucket.lambda_code_bucket.id
  s3_key    = aws_s3_object.data_fetcher_lambda_code.key

  vpc_config {
    subnet_ids         = [aws_subnet.vpc_subnet.id]
    security_group_ids = [aws_security_group.vpc_sg.id]
  }

  environment {
    variables = {
      DATA_STORE_S3_BUCKET = aws_s3_bucket.data_store.id
    }
  }

  tags = {
    Name = local.env_config.stack_name
  }
}

/*
* lambda needs to be able to access VPC
*/

resource "aws_iam_role_policy_attachment" "data_fetcher_lambda_vpc_access" {
  role       = aws_iam_role.data_fetcher_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

/*
* S3 access policies for lambda
*/

resource "aws_iam_policy" "data_store_s3_write_only_policy" {
  name        = "data_store_s3_write_only_policy"
  description = "Policy to allow lambda to write data to s3"
  policy      = data.aws_iam_policy_document.s3_write_only.json
}


resource "aws_iam_role_policy_attachment" "data_store_s3_write_only_policy" {
  role       = aws_iam_role.data_fetcher_lambda_role.name
  policy_arn = aws_iam_policy.data_store_s3_write_only_policy.arn
}



/*
* Terraform code to create a S3 bucket
*/

resource "aws_s3_bucket" "data_store" {
  bucket = "data-store-5897867"
}
