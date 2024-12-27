# Dead-letter Queue

resource "aws_sqs_queue" "user_mail_dlq" {
  name = "user-mail-dlq"
}


# sqs queue userMailsQ

resource "aws_sqs_queue" "user_mail_queue" {
  name                      = "user-mail-queue"
  delay_seconds             = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.user_mail_dlq.arn
    maxReceiveCount     = 2
  })


  tags = {
    Environment = "dev"
  }
}
