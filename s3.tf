# S3 bucket for website.
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.bucket-public-access-block,
    aws_s3_bucket_ownership_controls.bucket-ownership-controls,
  ]
  bucket = aws_s3_bucket.bucket.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "bucket-public-access-block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "bucket-ownership-controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.bucket.bucket
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = data.aws_iam_policy_document.iam-policy-1.json
}

data "aws_iam_policy_document" "iam-policy-1" {
  depends_on = [
    aws_s3_bucket_public_access_block.bucket-public-access-block,
    aws_s3_bucket_ownership_controls.bucket-ownership-controls,
  ]
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.domain_name}",
      "arn:aws:s3:::${var.domain_name}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

}


