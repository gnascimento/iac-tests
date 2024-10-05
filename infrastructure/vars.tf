variable "aws_profile" {
    type = string
    default = "localstack"
    description = "AWS Profile"
}

variable "aws_region" {
    type = string
    default = "us-east-1"
    description = "AWS Region"
}

variable "aws_account_id" {
    type = string
    default = "000000000000"
    description = "AWS Account"
}