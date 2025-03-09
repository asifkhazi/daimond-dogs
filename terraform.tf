terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
  cloud {

    organization = "hcta-demo-001"

    workspaces {
      name = "daiminfdogs-app-apsouth2-dev"
    }
  }
}