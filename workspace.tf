

# Create Databricks network configuration
resource "databricks_mws_networks" "this" {
  provider = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.project_name}-network-configuration"
  vpc_id             = aws_vpc.main_vpc.id
  subnet_ids         = [aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]
  security_group_ids = [aws_security_group.workspace_sg.id]
}


# Create Databricks credentials
resource "databricks_mws_credentials" "this" {
  provider = databricks.mws
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${var.project_name}-credentials"
}



# Create Databricks storage configuration
resource "databricks_mws_storage_configurations" "this" {
  provider = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.databricks_ws_bucket.bucket
  storage_configuration_name = "${var.project_name}-storage-configuration"

}



resource "time_sleep" "wait_time" {
  depends_on = [databricks_mws_storage_configurations.this]

  create_duration = "60s" # Wait for 60 seconds
}


# Create Databricks workspace
resource "databricks_mws_workspaces" "this" {
  provider = databricks.mws
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name
  aws_region     = var.region

  network_id = databricks_mws_networks.this.network_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id

  credentials_id           = databricks_mws_credentials.this.credentials_id
#   Remove comment only if you need kms
#   storage_customer_managed_key_id = databricks_mws_customer_managed_keys.this.customer_managed_key_id 
}


resource "databricks_metastore" "this" {
  provider      = databricks.mws
  name          = "${var.project_name}-metastore"
  region        = var.region
  force_destroy = true
}



resource "databricks_metastore_assignment" "this" {
  provider     = databricks.mws
  metastore_id = databricks_metastore.this.id
  workspace_id = databricks_mws_workspaces.this.workspace_id
  default_catalog_name = "hive_metastore"
}










# Create Databricks customer managed key (optional, remove if not needed)
# resource "databricks_mws_customer_managed_keys" "this" {
#   provider   = databricks.mws
#   account_id = var.databricks_account_id
#   aws_key_info {
#     key_arn   = aws_kms_key.example.arn
#     key_alias = aws_kms_alias.example.name
#   }
# }

# Create KMS key (optional, remove if not needed)
# resource "aws_kms_key" "example" {
#   description = "KMS key for Databricks workspace"
# }

# resource "aws_kms_alias" "example" {
#   name          = "alias/databricks-workspace-key"
#   target_key_id = aws_kms_key.example.key_id
# }

