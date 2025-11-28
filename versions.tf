terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"

  # Configure the backend to use S3 and DynamoDB for state management
  backend "s3" {
    bucket         = "sentinel-terraform-state-bucket-456"
    key            = "sentinel/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "sentinel-terraform-locks"
    encrypt        = true
  }

}