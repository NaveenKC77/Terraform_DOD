# s3 bucket to store code
resource "aws_s3_bucket" "my_code_bucket" {
  bucket = "my-agent-upload-code"

  tags = {
    Name        = "My Code bucket"
    Environment = "Dev"
  }
}