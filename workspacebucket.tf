
resource "aws_s3_bucket" "databricks_ws_bucket" {
  bucket = "${var.workspace_name}-bucket"
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.databricks_ws_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "state" {
  bucket = aws_s3_bucket.databricks_ws_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket     = aws_s3_bucket.databricks_ws_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.state]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage_bucket" {
  bucket = aws_s3_bucket.databricks_ws_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket                  = aws_s3_bucket.databricks_ws_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Attach bucket policy
resource "aws_s3_bucket_policy" "databricks_bucket_policy" {
  bucket = aws_s3_bucket.databricks_ws_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Grant Databricks Access"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        }
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "${aws_s3_bucket.databricks_ws_bucket.arn}/*",
          "${aws_s3_bucket.databricks_ws_bucket.arn}"
        ]
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/DatabricksAccountId" = [var.databricks_account_id]
          }
        }
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.root_storage_bucket ]
}




# Attach permissions policy to the role
resource "aws_iam_policy" "databricks_role_policy" {
  name = "${var.project_name}-ws-access-iam-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.project_name}-databricks-${var.workspace_name}"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          aws_s3_bucket.databricks_ws_bucket.arn,
          "${aws_s3_bucket.databricks_ws_bucket.arn}/*"
        ],
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-uc-access"
        ],
        "Effect" : "Allow"
      }
    ]
  })
}












# 1. Create IAM Role
resource "aws_iam_role" "databricks_ws_bucket_role" {
  name                = "${var.project_name}-ws-bucket"
  assume_role_policy  = data.aws_iam_policy_document.workspace_policy_role.json
  managed_policy_arns = [aws_iam_policy.databricks_role_policy.arn]
}







