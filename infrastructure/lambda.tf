
resource "aws_lambda_function" "lambda_reports" {
  function_name = "lambda-reports"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "lambdas/lambda_reports.zip"
  handler       = "lambda_reports.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_report_role.arn
  
   environment {
     variables = {
       S3_REPORT_BUCKET = aws_s3_bucket.reports_bucket.bucket
     }
   }

  # Attach the Lambda function to the VPC and subnets
  vpc_config {
    subnet_ids         = [aws_subnet.application_subnet.id]   # app_subnet
    security_group_ids = [aws_security_group.lambda_sg.id]    # Security group for Lambda
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
       S3_REPORT_BUCKET = aws_s3_bucket.reports_bucket.bucket
     }
   }
  
  # Attach the Lambda function to the VPC and subnets
  vpc_config {
    subnet_ids         = [aws_subnet.application_subnet.id]   # app_subnet
    security_group_ids = [aws_security_group.lambda_sg.id]    # Security group for Lambda
  }
}