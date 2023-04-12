# terraform {
#   cloud {
#     organization = "pbl-terraform"

#     workspaces {
#       name = "pbl-dev"
#     }
#   }
# }

resource "aws_s3_bucket" "terraform_state" {
  bucket = "manny-dev-terraform-bucket"
  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-Terraform-State-Store-%s", var.name, var.environment)
    },
  )
}

data "aws_s3_bucket" "terraform_state" {
  bucket = "manny-dev-terraform-bucket"
}

# terraform {
#   backend "s3" {
#     bucket         = "manny-dev-terraform-bucket"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }