terraform {
  required_version = ">= 0.12.20"
  backend "local" {
  }
}

provider "aws" {
  version = "2.50.0"
  region = var.region
}