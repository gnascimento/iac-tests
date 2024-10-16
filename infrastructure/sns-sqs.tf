resource "aws_sns_topic" "batch_request_sns" {
  name = var.sns_batch_request_topic
}

resource "aws_sqs_queue" "sqs_batch_request_queue" {
  name = var.sns_batch_request_queue
}

resource "aws_sns_topic_subscription" "sns_to_sqs_request" {
  topic_arn = aws_sns_topic.batch_request_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_batch_request_queue.arn
}
