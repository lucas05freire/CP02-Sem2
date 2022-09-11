# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# REGION
provider "aws" {
    region                  = "us-east-1"
    shared_credentials_file = ".aws/credentials"
}

# BUCKET S3
resource "aws_s3_bucket" "s3-95128" {
  bucket = "s3-95128"
}

# STATIC SITE
resource "aws_s3_bucket_website_configuration" "sites3" {
  bucket = aws_s3_bucket.s3-95128.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ACL S3
resource "aws_s3_bucket_acl" "acls3" {
  bucket = aws_s3_bucket.s3-95128.id
  acl    = "public-read"
}

#S3 UPLOAD OBJECT
resource "aws_s3_bucket_object" "error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.s3-95128.id
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.s3-95128.id
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# POLICY S3
resource "aws_s3_bucket_policy" "policys3" {
  bucket = aws_s3_bucket.s3-95128.id

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::s3-95128/*",
      }
    ]
	})
}

# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "versionings3" {
  bucket = aws_s3_bucket.s3-95128.id
  versioning_configuration {
    status = "Enabled"
  }
}