resource "random_pet" "lambda_bucket_name" {
  prefix = "api"
  length = 4
}

#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-encryption
resource "aws_s3_bucket" "lambda_bucket" {
  #checkov:skip=CKV2_AWS_61:No need for lifecycle configurations
  #checkov:skip=CKV_AWS_18:No need for access logging
  #checkov:skip=CKV_AWS_144:No need for cross-region replication
  #checkov:skip=CKV_AWS_145:No need for KMS encryption
  #checkov:skip=CKV_AWS_21:No need for bucket versionsing
  #checkov:skip=CKV2_AWS_62:No need for event notifications
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket_public_block" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "archive_file" "api-lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../src.zip"
}

resource "aws_s3_object" "api-object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "src.zip"
  source = data.archive_file.api-lambda.output_path
  etag   = filemd5(data.archive_file.api-lambda.output_path)
}
