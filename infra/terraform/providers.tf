terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.20" }
    helm = { source = "hashicorp/helm", version = "~> 2.7" }
  }
  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}
