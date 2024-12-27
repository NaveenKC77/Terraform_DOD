output "user-mail-queue-arn" {
  value = aws_sqs_queue.user_mail_queue.arn
}
output "user-mail-dlq-arn" {
  value = aws_sqs_queue.user_mail_dlq.arn
}

output "user_mail_rest_api_arn" {
  value = aws_api_gateway_rest_api.user_mail_api.arn
}