#  Create an S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "sentinel-terraform-state-bucket-456" # Use a unique name

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform Remote State"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket 
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a DynamoDB table for locks
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sentinel-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # Required key name for Terraform
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}