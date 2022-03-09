
## CRIACAO DE BUCKET S3 COM VERSIONAMENTO, ACESSO PRIVADO E POLICY ANEXADA

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

#CREATE BUCKET
resource "aws_s3_bucket" "bucket_test" {
  bucket = "finance-sap-boletos-dev-test"
}

#VERSIONING
resource "aws_s3_bucket_versioning" "bucket_test_versioning" {
  bucket = aws_s3_bucket.bucket_test.id
  versioning_configuration {
    status = "Enabled"
  }
}

#ACL
resource "aws_s3_bucket_acl" "bucket_test_acl" {
  bucket = aws_s3_bucket.bucket_test.id
  acl    = "private"
}

#POLICY
resource "aws_s3_bucket_policy" "bucket_test_policy" {
  bucket = aws_s3_bucket.bucket_test.id

  #JSON
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Liberacao de acesso ao bucket"
    Statement = [
      {
        Sid       = "Acesso bucket"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.bucket_test.arn,
          "${aws_s3_bucket.bucket_test.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "bucket_test_access" {
  bucket = aws_s3_bucket.bucket_test.id

  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}