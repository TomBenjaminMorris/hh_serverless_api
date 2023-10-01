////////////////// Generic Labmda API IAM Config //////////////////

resource "aws_iam_role" "lambda_exec" {
  name = "hh_serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


////////////////// Send Email IAM Config //////////////////

resource "aws_iam_role" "lambda_to_ses_role" {
  name = "hh_serverless_lambda_ses_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_to_ses_basic_attachment" {
  role       = aws_iam_role.lambda_to_ses_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_to_ses_attachment" {
  role       = aws_iam_role.lambda_to_ses_role.name
  policy_arn = aws_iam_policy.lambda_to_ses_policy.arn
}

data "aws_iam_policy_document" "lambda_to_ses_policy_document" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
  }
}

resource "aws_iam_policy" "lambda_to_ses_policy" {
  name   = "lambda_to_ses_policy"
  policy = data.aws_iam_policy_document.lambda_to_ses_policy_document.json
}