data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.59"
    }
  }

  backend "s3" {
    bucket  = "replaceme"
    key     = "replaceme"
    region  = "replaceme"
    profile = "webboggle-deploy-profile"
  }
}

provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/cicd"
  }
}
