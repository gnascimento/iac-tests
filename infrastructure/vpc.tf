resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "application_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
}

# resource "aws_subnet" "database_subnet" {
#   vpc_id     = aws_vpc.demo_vpc.id
#   cidr_block = "10.0.2.0/24"
# }

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id       = aws_vpc.demo_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"
  subnet_ids   = [aws_subnet.application_subnet.id]

  # Associate security groups if needed for further restrictions (optional)
  security_group_ids = [aws_security_group.dynamodb_sg.id]

  tags = {
    Name = "dynamodb-vpc-endpoint"
  }
}
