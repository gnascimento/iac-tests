resource "aws_security_group" "lambda_sg" {
  name   = "lambda_security_group"
  vpc_id = aws_vpc.demo_vpc.id

  # Ingress rules (define what can access the Lambda function)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere (you can restrict this further)
  }

  # Egress rules (define what Lambda can access)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "lambda-security-group"
  }
}


# Security group for VPC Endpoint (you can customize rules as needed)
resource "aws_security_group" "dynamodb_sg" {
  name        = "dynamodb-vpc-sg"
  description = "Allow access to DynamoDB VPC Endpoint"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  # Allow from VPC CIDR range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}