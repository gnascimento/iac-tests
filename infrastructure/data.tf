data "aws_sns_topic" "sns_batch_request_topic_info" {
    name = var.sns_batch_request_topic
    depends_on = [ aws_sns_topic.batch_request_sns ]
}

data "aws_sqs_queue" "sqs_batch_request_queue_info" {
  name = var.sns_batch_request_queue
  depends_on = [ aws_sqs_queue.sqs_batch_request_queue ]
}


data "aws_lambda_function" "lambda_reports" {
  function_name = var.lambda_reports
  depends_on = [ aws_lambda_function.lambda_reports ]
}

# Retrieve information about the current caller identity from AWS STS
data "aws_caller_identity" "current" {}