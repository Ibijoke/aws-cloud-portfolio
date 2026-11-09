# Generate a unique bucket name using the project name and AWS account ID.
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}-website"

  tags = {
    Name        = "${var.project_name}-website"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Block all public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption using S3-managed keys.
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning to preserve previous object versions.
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enforce bucket ownership and disable ACLs.
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}