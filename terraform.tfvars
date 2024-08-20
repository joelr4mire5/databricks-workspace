#Fill this variable to connect with your providers, define names and subnet sizing

aws_profile                         = "" #How to authenticate: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
aws_account_id                      = ""
# databricks_profile                = ""
client_secret                       = "" #How to authenticate: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
client_id                           = "" #How to authenticate: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
databricks_account_id               = "" #How to authenticate: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
workspace_name                      = ""
region                              = ""
project_name                        = ""
cidr_block                          = ""
private_subnet_cidrs                = ["", ""]
azs                                 = ["", ""]
aws_ws_bucket_iam_role_name         = ""
