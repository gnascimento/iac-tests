output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

// Api Gateway
output "aws_api_gateway_http_method" {
  value = aws_api_gateway_method.any_request_method.http_method
}

output "aws_api_gateway_http_authorization" {
  value = aws_api_gateway_method.any_request_method.authorization
}

output "aws_api_gateway_integration_http_method" {
  value = aws_api_gateway_integration.request_integration.integration_http_method
}

output "aws_api_gateway_integration_type" {
  value = aws_api_gateway_integration.request_integration.type
}

// Dynamo DB

output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.product_table.name
}

output "aws_dynamodb_table_hash_key" {
  value = aws_dynamodb_table.product_table.hash_key
}

// IAM

# Output for SQS Read Policy ARN
output "aws_iam_policy_sqs_read_policy_arn" {
  value = aws_iam_policy.sqs_read_policy.arn
  description = "The ARN of the SQS read policy."
}

# Output for DynamoDB Access Policy ARN
/* output "aws_iam_policy_dynamodb_access_policy_arn" {
  value = aws_vpc_endpoint.dynamodb_endpoint.arn
  description = "The ARN of the DynamoDB access policy."
} */

# Output for Lambda Report Role ARN
output "aws_iam_role_lambda_report_role_arn" {
  value = aws_iam_role.lambda_report_role.arn
  description = "The ARN of the Lambda report role."
}

# Output for SQS policy attachment to Lambda report role
output "aws_iam_role_policy_attachment_attach_sqs_to_lambda_report_role_id" {
  value = aws_iam_role_policy_attachment.attach_sqs_to_lambda_report_role.id
  description = "The ID of the policy attachment for SQS to Lambda report role."
}

# Output for DynamoDB policy attachment to Lambda report role
/* output "aws_iam_role_policy_attachment_attach_dynamodb_policy_to_lambda_report_role_id" {
  value = aws_iam_role_policy_attachment.attach_dynamodb_policy_to_lambda_report_role.id
  description = "The ID of the policy attachment for DynamoDB to Lambda report role."
} */

# Output for S3 policy attachment to Lambda report role
output "aws_iam_role_policy_attachment_attach_s3_policy_to_lambda_report_role_id" {
  value = aws_iam_role_policy_attachment.attach_s3_policy_to_lambda_report_role.id
  description = "The ID of the policy attachment for S3 to Lambda report role."
}

# Output for SNS Publish Policy ARN
output "aws_iam_policy_sns_publish_policy_arn" {
  value = aws_iam_policy.sns_publish_policy.arn
  description = "The ARN of the SNS publish policy."
}

# Output for Lambda Request Role ARN
output "aws_iam_role_lambda_request_role_arn" {
  value = aws_iam_role.lambda_request_role.arn
  description = "The ARN of the Lambda request role."
}

# Output for SNS policy attachment to Lambda request role
output "aws_iam_role_policy_attachment_attach_sns_policy_to_lambda_request_role_id" {
  value = aws_iam_role_policy_attachment.attach_sns_policy_to_lambda_request_role.id
  description = "The ID of the policy attachment for SNS to Lambda request role."
}

# Output for S3 report read policy attachment to Lambda request role
output "aws_iam_role_policy_attachment_attach_s3_policy_to_lambda_request_role_id" {
  value = aws_iam_role_policy_attachment.attach_s3_policy_to_lambda_request_role.id
  description = "The ID of the policy attachment for S3 read access to Lambda request role."
}

# Lambda function
output "lambda_reports_name" {
  value = data.aws_lambda_function.lambda_reports.function_name
  description = "Name of the lambda function for reports"
}

output "lambda_reports_arn" {
  value = data.aws_lambda_function.lambda_reports.arn
  description = "Name of the lambda function for reports"
}


// Lambda
# Output for Lambda Reports function
output "aws_lambda_function_lambda_reports_function_name" {
  value = aws_lambda_function.lambda_reports.function_name
}

output "aws_lambda_function_lambda_reports_role" {
  value = aws_lambda_function.lambda_reports.role
}

# Output for Lambda Request function
output "aws_lambda_function_lambda_request_function_name" {
  value = aws_lambda_function.lambda_request.function_name
}

output "aws_lambda_function_lambda_request_role" {
  value = aws_lambda_function.lambda_request.role
}

/* # Output for SQS to Lambda trigger
output "aws_lambda_event_source_mapping_lambda_report_sqs_trigger_id" {
  value = aws_lambda_event_source_mapping.lambda_report_sqs_trigger.id
}
 */