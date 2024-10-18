resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "application_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
}



resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  count = var.aws_profile == "localstack"? 0 : 1
  vpc_id       = aws_vpc.demo_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"  # Explicitly setting the type to Gateway
  tags = {
    Name = "dynamodb-vpc-endpoint"
  }
}
