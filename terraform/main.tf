# ----------------------------------
# Terraform configuration
# ----------------------------------
terraform {
  required_version = ">=1.1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# ----------------------------------
# Provider
# ----------------------------------
provider "aws" {
  profile    = "terraform"
  region     = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# ----------------------------------
# Variables
# ----------------------------------
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "project" {}
variable "environment" {}
variable "domain" {}