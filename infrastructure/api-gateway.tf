resource "aws_api_gateway_rest_api" "demo_api" {
  name = "demo-app-api"
}

resource "aws_api_gateway_resource" "request_resource" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  parent_id   = aws_api_gateway_rest_api.demo_api.root_resource_id
  path_part   = "request"
}

resource "aws_api_gateway_method" "any_request_method" {
  rest_api_id   = aws_api_gateway_rest_api.demo_api.id
  resource_id   = aws_api_gateway_resource.request_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_integration" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.request_resource.id
  http_method = aws_api_gateway_method.any_request_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_request.invoke_arn
}
