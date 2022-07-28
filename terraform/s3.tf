resource "random_pet" "lambda_bucket_name" {
  prefix = "api"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

data "archive_file" "api-lambda" {
  type = "zip"

  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../src.zip"
}

resource "aws_s3_object" "api-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "src.zip"
  source = data.archive_file.api-lambda.output_path

  etag = filemd5(data.archive_file.api-lambda.output_path)
}