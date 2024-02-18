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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "RandomPasswordPyLambdaRole"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "RandomPasswordPy" {
  function_name    = "RandomPasswordPy"
  filename         = "${data.archive_file.RandomPasswordPy.output_path}"
  source_code_hash = "${data.archive_file.RandomPasswordPy.output_base64sha256}"
  role    = "arn:aws:iam::735522019233:role/service-role/PythonHelloWorld-role-3oceq5at"
  handler = "RandomPasswordPy.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      greeting = "RandomPasswordPy"
    }
  }
}

resource "aws_lambda_function_url" "RandomPasswordPy" {
  function_name      = "RandomPasswordPy"
  authorization_type = "NONE"
}

