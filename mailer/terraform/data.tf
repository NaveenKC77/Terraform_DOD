data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.root}/user_mail_lambda_function.zip"
  depends_on  = [null_resource.main]
}