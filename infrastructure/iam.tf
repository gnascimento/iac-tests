### Lambda report iam policies


resource "aws_iam_policy" "sqs_read_policy" {
  name        = "sqs-read-policy"
  description = "Policy to allow reading messages from an SQS queue"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        "Resource": data.aws_sqs_queue.sqs_batch_request_queue_info.arn
      }
    ]
  })
}


resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "DynamoDBSubnetAccessPolicy"
  description = "Policy to allow access to DynamoDB only from the specific application subnet"
  depends_on = [  aws_vpc_endpoint.dynamodb_endpoint ]

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Resource": "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.product_table.name}",
        "Condition": {
          "StringEquals": {
            "aws:SourceVpce": "${aws_vpc_endpoint.dynamodb_endpoint.id}"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_s3_access_policy" {
  name        = "LambdaS3FullAccessPolicy"
  description = "Policy to allow the Lambda function to read and write to the S3 bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.reports_bucket.bucket}/*",   # Access to all objects in the bucket
          "arn:aws:s3:::${aws_s3_bucket.reports_bucket.bucket}"      # Access to list the bucket
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_sqs_to_lambda_report_role" {
  role       = aws_iam_role.lambda_report_role.name
  policy_arn = aws_iam_policy.sqs_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy_to_lambda_report_role" {
  role       = aws_iam_role.lambda_report_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}


resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_lambda_report_role" {
  role       = aws_iam_role.lambda_report_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access_lambda_reports" {
    role       = aws_iam_role.lambda_report_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role" "lambda_report_role" {
  name = "lambda-report-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"  # For AWS Lambda
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "lambda-report-role"
  }
}

## Lambda request

resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publish-policy"
  description = "Policy to allow sending messages to an SNS topic"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sns:Publish",
        "Resource": "arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_sns_topic.batch_request_sns.name}"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_report_read_access_policy" {
  name        = "LambdaS3ReadOnlyAccessPolicy"
  description = "Policy to allow the Lambda function to read and write to the S3 bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.reports_bucket.bucket}/*",   # Access to all objects in the bucket
          "arn:aws:s3:::${aws_s3_bucket.reports_bucket.bucket}"      # Access to list the bucket
        ]
      }
    ]
  })
}


resource "aws_iam_role" "lambda_request_role" {
  name = "lambda-request-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"  # For AWS Lambda
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "lambda-request-role"
  }
}


resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_lambda_request_role" {
  role       = aws_iam_role.lambda_request_role.name
  policy_arn = aws_iam_policy.lambda_s3_report_read_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_sns_policy_to_lambda_request_role" {
  role       = aws_iam_role.lambda_request_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access_lambda_request" {
    role       = aws_iam_role.lambda_request_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

### Allows SNS to publish to SQS queue

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_batch_request_queue.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "sns.amazonaws.com"
        },
        "Action": "sqs:SendMessage",
        "Resource": "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.sqs_batch_request_queue.name}",
        "Condition": {
          "ArnEquals": {
            "aws:SourceArn": "arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_sns_topic.batch_request_sns.name}"
          }
        }
      }
    ]
  })
}
