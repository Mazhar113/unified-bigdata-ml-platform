variable "aws_region" { type = string, default = "us-east-1" }
variable "cluster_name" { type = string, default = "unified-platform-eks" }
variable "environment" { type = string, default = "dev" }
variable "owner_tag" { type = string, default = "data-platform" }
variable "public_subnets" { type = list(string), default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnets" { type = list(string), default = ["10.0.10.0/24","10.0.11.0/24"] }
