terraform {
  backend "s3" {
    bucket = "techlanches-terraform"
    key    = "techlanches-k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.regionDefault
}
