# Rest API

resource "aws_api_gateway_rest_api" "user_mail_api" {
  name        = "user-mail-api"
  description = "POST records to SQS queue"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# POST Method

resource "aws_api_gateway_method" "post_method" {
  rest_api_id      = aws_api_gateway_rest_api.user_mail_api.id
  resource_id      = aws_api_gateway_rest_api.user_mail_api.root_resource_id
  api_key_required = false
  http_method      = "POST"
  authorization    = "NONE"
}

# API SQS Integration

resource "aws_api_gateway_integration" "user_mail_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.user_mail_api.id
  resource_id             = aws_api_gateway_rest_api.user_mail_api.root_resource_id
  http_method             = "POST"
  type                    = "AWS"
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"
  credentials             = aws_iam_role.user_mail_rest_api_role.arn
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.user_mail_queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}
# # basic 200 handler for successful requests with a custom response message
resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id       = aws_api_gateway_rest_api.user_mail_api.id
  resource_id       = aws_api_gateway_rest_api.user_mail_api.root_resource_id
  http_method       = aws_api_gateway_method.post_method.http_method
  status_code       = aws_api_gateway_method_response.method_response_200.status_code
  selection_pattern = "^2[0-9][0-9]" // regex pattern for any 200 message that comes back from SQS

  response_templates = {
    "application/json" = "{\"message\": \"great success!\"}"
  }

  depends_on = ["aws_api_gateway_integration.user_mail_api_integration"]
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.user_mail_api.id
  resource_id = aws_api_gateway_rest_api.user_mail_api.root_resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# API Deployment
resource "aws_api_gateway_deployment" "user_mail_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_mail_api.id

  depends_on = [
    "aws_api_gateway_integration.user_mail_api_integration",
  ]
}
