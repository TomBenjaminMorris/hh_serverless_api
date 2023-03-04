terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  backend "s3" {
    bucket = "tbm-tf-state-bucket"
    key    = "hapihour_lambda"
    region = "eu-west-1"
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}