terraform {
  required_version = "~> 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.1"
    }
  }
}

data "aws_route53_zone" "selected" {
  zone_id = var.zone_id
}
