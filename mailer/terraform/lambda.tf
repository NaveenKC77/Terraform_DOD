# lambda function

resource "aws_lambda_function" "user_mail_lambda" {

  function_name = "user_mail_function"
  role          = aws_iam_role.user_mail_lambda_role.arn
  handler       = "index.handler"
  architectures = ["x86_64"]

  #  filename = "C:\\Users\\jungk\\Sites\\GithubRepos\\mailLambda.zip"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  filename         = local.archive


  runtime = "nodejs22.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.user_mail_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.user_mail_lambda.function_name
  batch_size       = 1
}