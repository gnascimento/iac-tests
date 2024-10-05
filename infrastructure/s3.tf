resource "aws_s3_bucket" "reports_bucket" {
  bucket = "demoappreports"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "demoapplambda"
}

# Zip the Lamda function on the fly
data "archive_file" "zipped_lambda_report" {
  type        = "zip"
  source_file = "lambdas/lambda_reports.py"
  output_path = "lambdas/lambda_reports.zip"
}


resource "aws_s3_object" "lambda_report_obj" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambdas/lambda_reports.zip"
  source = "lambdas/lambda_reports.zip"  # Local path to lambda function
}


# Zip the Lamda function on the fly
data "archive_file" "zipped_lambda_request" {
  type        = "zip"
  source_file = "lambdas/lambda_request.py"
  output_path = "lambdas/lambda_request.zip"
}


resource "aws_s3_object" "lambda_request_obj" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambdas/lambda_request.zip"
  source = "lambdas/lambda_request.zip"  # Local path to lambda function
}

