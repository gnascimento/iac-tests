terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = var.aws_profile
  s3_use_path_style = true
}

provider "archive" {
  
}