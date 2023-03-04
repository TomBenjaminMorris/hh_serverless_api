resource "aws_lambda_function" "deleteOne" {
  function_name = "deleteOne"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.api-object.key

  runtime = "nodejs18.x"
  handler = "handler.deleteOne"

  source_code_hash = data.archive_file.api-lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "deleteOne" {
  name = "/aws/lambda/${aws_lambda_function.deleteOne.function_name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "deleteOne" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.deleteOne.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "deleteOne" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "DELETE /bar"
  target    = "integrations/${aws_apigatewayv2_integration.deleteOne.id}"
}

resource "aws_lambda_permission" "deleteOne" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deleteOne.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}