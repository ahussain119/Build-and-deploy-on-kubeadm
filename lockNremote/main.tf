locals {
  projectname="kubeadm-tomcat"
  region="ca-central-1"
}

output "bucket_name" {
  value = aws_s3_bucket.terraform-state.bucket
}
output "table_name" {
  value = aws_dynamodb_table.state_lock_table.name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = local.region
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-${local.projectname}"
}

resource "aws_s3_bucket_versioning" "terraform-state" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state_lock_table" {
  name           = "terraform_state_lock_${local.projectname}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

