
resource "aws_lambda_function" "lambda_reports" {
  function_name = var.lambda_reports
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "lambdas/lambda_reports.zip"
  handler       = "lambda_reports.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_report_role.arn
  
  environment {
    variables = {
      S3_REPORT_BUCKET = aws_s3_bucket.reports_bucket.bucket
      PRODUCTS_TABLE = aws_dynamodb_table.product_table.name
    }
  }

  # Attach the Lambda function to the VPC and subnets
  vpc_config {
    subnet_ids         = [aws_subnet.application_subnet.id]   # app_subnet
    security_group_ids = [aws_security_group.lambda_sg.id]    # Security group for Lambda
  }

  tags = {
    Name = "lambda-reports"
  }
}

resource "aws_lambda_function" "lambda_request" {
  function_name = "lambda-request"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "lambdas/lambda_request.zip"
  handler       = "lambda_request.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_request_role.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = data.aws_sns_topic.sns_batch_request_topic_info.arn
    }
  }
  
  # Attach the Lambda function to the VPC and subnets
  vpc_config {
    subnet_ids         = [aws_subnet.application_subnet.id]   # app_subnet
    security_group_ids = [aws_security_group.lambda_sg.id]    # Security group for Lambda
  }
}


/* # Configure trigger SQS to Lambda Function
resource "aws_lambda_event_source_mapping" "lambda_report_sqs_trigger" {
    event_source_arn = data.aws_sqs_queue.sqs_batch_request_queue_info.arn
    function_name    = data.aws_lambda_function.lambda_reports.arn
    batch_size       = 5 # Number of messages that the lambda can process at once
}
 */