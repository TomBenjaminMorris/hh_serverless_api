#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "getLocations" {
  #checkov:skip=CKV_AWS_116:No need for DLQ
  #checkov:skip=CKV_AWS_115:Account limits prohibit this
  #checkov:skip=CKV_AWS_50:No need for tracing
  #checkov:skip=CKV_AWS_117:No need for a VPC
  #checkov:skip=CKV_AWS_272:No need for code signing
  function_name = "getLocations"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.api-object.key

  runtime = "nodejs18.x"
  handler = "handler.getLocations"

  source_code_hash = data.archive_file.api-lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "getLocations" {
  #checkov:skip=CKV_AWS_158:Standard encryption will suffice
  #checkov:skip=CKV_AWS_338:One month will suffice
  name              = "/aws/lambda/${aws_lambda_function.getLocations.function_name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "getLocations" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.getLocations.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "getLocations" {
  #checkov:skip=CKV_AWS_309:No need for a custom authorizer
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /locations"
  target    = "integrations/${aws_apigatewayv2_integration.getLocations.id}"
}

resource "aws_lambda_permission" "getLocations" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getLocations.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
