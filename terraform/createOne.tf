resource "aws_lambda_function" "createOne" {
  function_name = "createOne"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.api-object.key

  runtime = "nodejs18.x"
  handler = "handler.createOne"

  source_code_hash = data.archive_file.api-lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "createOne" {
  name = "/aws/lambda/${aws_lambda_function.createOne.function_name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "createOne" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.createOne.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "createOne" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /bar"
  target    = "integrations/${aws_apigatewayv2_integration.createOne.id}"
}

resource "aws_lambda_permission" "createOne" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.createOne.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}