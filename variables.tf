variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-project"
}

variable "workspace_name" {
  description = "The name of the workspace"
  type        = string
  default     = "my-workspace-dev"
}




variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = string
  default     = "10.0.11.0/24"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "aws_profile" {
  description = "The AWS CLI profile name to use"
  type        = string
  default     = "aws-joel-profile"  # Change to your desired profile name
}

variable "region" {
  description = "Region of the VPC"
  type        = string
  default     = "us-west-2"  # Change to your desired region name
}


variable "s3wsbucketname" {
  description = "S3 Bucket Name"
  type        = string
  default     = "joel-sts"  # Change to your desired profile name
}

variable "client_id" {
  description = "Service provider databricks client id"
  type        = string

}

variable "client_secret" {
  description = "Service provider databricks client secret"
  type        = string

}

variable "databricks_account_id" {
  description = "Service provider databricks client secret"
  type        = string

}



variable "aws_ws_bucket_iam_role_name" {
  description = "Name of the AWS IAM role to assume"
  type        = string
}


variable "aws_account_id" {
  description = "Your AWS account ID"
  type        = string
}

# variable "databricks_profile" {
#   description = "Your databricks profile"
#   type        = string
# }


#Optional

# variable "kms_key_arn" {
#   description = "ARN of the KMS key"
#   type        = string
# }