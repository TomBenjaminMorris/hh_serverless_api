resource "aws_lambda_function" "sendEmail" {
  function_name = "sendEmail"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.api-object.key

  runtime = "nodejs14.x"
  handler = "sendEmail.handler"

  source_code_hash = data.archive_file.api-lambda.output_base64sha256

  role = aws_iam_role.lambda_to_ses_role.arn
}

resource "aws_cloudwatch_log_group" "sendEmail" {
  name = "/aws/lambda/${aws_lambda_function.sendEmail.function_name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "sendEmail" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.sendEmail.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "sendEmail" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /sendEmail"
  target    = "integrations/${aws_apigatewayv2_integration.sendEmail.id}"
}

resource "aws_lambda_permission" "sendEmail" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sendEmail.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}