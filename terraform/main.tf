provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "mamourcloudresume"

  website {
    index_document = "index.html"
    #error_document = "error.html"
  }

  tags = {
    Name = "CloudResumeWebsite"
  }
}

resource "aws_s3_bucket_public_access_block" "resume_public_access" {
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "resume_policy" {
  bucket = aws_s3_bucket.resume_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.resume_bucket.arn}/*"
      }
    ]
  })
}

output "website_url" {
  value = aws_s3_bucket.resume_bucket.website_endpoint
}

