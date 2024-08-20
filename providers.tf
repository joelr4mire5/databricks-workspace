#This file is being used to authenticate terraform on aws and databricks
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50.0"  # Use the latest version available
    }
  }
}

provider "aws" {
  region  = var.region  # Modify the region as needed
  profile = var.aws_profile
}


provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

