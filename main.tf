terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  # profile = "default"  
  region = "us-east-1"
}
# Modules
module "website" {
  source = "./iac"
  bucket_name = "taxidriverframes" # The bucket name you want to use.
}