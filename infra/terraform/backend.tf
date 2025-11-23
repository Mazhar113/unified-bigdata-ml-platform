terraform {
  backend "s3" {
    bucket         = "replace-me-terraform-state-<your-unique-suffix>"
    key            = "unified-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "replace-me-terraform-locks"
    encrypt        = true
  }
}
