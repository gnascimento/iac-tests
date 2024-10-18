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


variable "sns_batch_request_topic" {
  type = string
  default = "sns-batch-request"
  description = "SNS batch request topic name"
}

variable "sns_batch_request_queue" {
  type = string
  default = "sqs-batch-request-queue"
  description = "SNS batch request queue"
}

variable "lambda_reports" {
  type = string
  default = "lambda-reports"
  description = "Lambda reports name"
}