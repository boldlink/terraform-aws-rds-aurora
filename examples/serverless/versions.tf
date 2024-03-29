terraform {
  required_version = ">= 0.14.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
