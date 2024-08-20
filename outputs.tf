# Output the role ARN
output "cross_account_role_arn" {
  value = aws_iam_role.cross_account_role.arn
}


# # Outputs
# output "ws_bucket_role_arn" {
#   value = aws_iam_role.databricks_ws_bucket_role.arn
# }

# output "ws_bucket_name" {
#   value = aws_s3_bucket.databricks_ws_bucket.id
# }

# output "workspace_url" {
#   value = databricks_mws_workspaces.this.workspace_url
# }
