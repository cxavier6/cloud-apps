# s3 bucket to store the terraform state file
# This file is used to define the versions of the providers that will be used in the project.

terraform {
  backend "s3" {
    bucket  = "cloud-apps-infra-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.15"
    }
  }
}
