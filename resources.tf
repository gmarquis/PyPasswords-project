data "archive_file" "RandomPasswordPy" {
  type        = "zip"
  source_file = "RandomPasswordPy.py"
  output_path = "RandomPasswordPy.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "RandomPasswordPy" {
  name               = "RandomPasswordPy"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "RandomPasswordPy" {
  function_name    = "RandomPasswordPy"
  filename         = "${data.archive_file.RandomPasswordPy.output_path}"
  source_code_hash = "${data.archive_file.RandomPasswordPy.output_base64sha256}"
  role              = aws_iam_role.RandomPasswordPy.arn
  handler          = "RandomPasswordPy.lambda_handler"
  runtime          = "python3.9"

  environment {
    variables = {
      greeting = "RandomPasswordPy"
    }
  }
}

resource "aws_lambda_function_url" "RandomPasswordPy" {
  function_name       = aws_lambda_function.RandomPasswordPy.arn
  authorization_type = "NONE"
}

output "function_url" {
  description = "Function URL."
  value       = aws_lambda_function_url.RandomPasswordPy.function_url
}
