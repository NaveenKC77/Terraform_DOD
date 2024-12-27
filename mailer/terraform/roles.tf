
# IAM Roles

#Rest API Role

resource "aws_iam_role" "user_mail_rest_api_role" {
  name = "user-mail-rest-api-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Policies to allow API to make logs and send message to sqs
resource "aws_iam_policy" "user_mail_rest_api_policy" {
  name = "user-mail-rest-api-permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:SendMessageBatch",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "sqs:CreateQueue",
          "sqs:ListQueueTags",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:SetQueueAttributes"
        ],
        "Resource": "${aws_sqs_queue.user_mail_queue.arn}"
      },
      {
        "Effect": "Allow",
        "Action": "sqs:ListQueues",
        "Resource": "*"
      }      
    ]
}
EOF
}
# attaching role to policies

resource "aws_iam_role_policy_attachment" "user_mail_api_attachment" {
  role       = aws_iam_role.user_mail_rest_api_role.name
  policy_arn = aws_iam_policy.user_mail_rest_api_policy.arn
}


# iam role fpr lambda function

resource "aws_iam_role" "user_mail_lambda_role" {
  name = "user-mail-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Policies to allow API to make logs and send message to sqs
resource "aws_iam_policy" "user_mail_lambda_policy" {
  name = "user-mail-lambda-permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
# attaching role to policies

resource "aws_iam_role_policy_attachment" "user_mail_lambda_attachment" {
  role       = aws_iam_role.user_mail_lambda_role.name
  policy_arn = aws_iam_policy.user_mail_lambda_policy.arn
}
