# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_access_point
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration

locals {
  full_name = "${var.asset_id}-${var.short_name}-${var.asset_group}"
}

resource "aws_s3_bucket" "this" {
  bucket = var.name != null ? var.name : local.full_name
  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags != null ? {
    for k, v in var.tags : k => v
  } : {}
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.bucket_version != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CORS configuration
# resource "aws_s3_bucket_cors_configuration" "this" {
#   bucket = aws_s3_bucket.this.id
#   # 使用 try 处理整个变量为 null 的情况
#   dynamic "cors_rule" {
#     for_each = try(var.cors_rule, [])
#     content {
#       allowed_headers = try(cors_rule.value.allowed_headers, null)
#       allowed_methods = cors_rule.value.allowed_methods
#       allowed_origins = cors_rule.value.allowed_origins
#       expose_headers  = try(cors_rule.value.expose_headers, null)
#       max_age_seconds = try(cors_rule.value.max_age_seconds, null)
#     }
#   }
# }

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  count = length(var.cors_rule) > 0 ? 1 : 0
  # 变量默认值是 []，所以即使没传变量，循环也会安全跳过，不会报错
  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      # 这里的属性直接赋值即可。如果是 null，Terraform 会自动忽略该配置项
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# create s3 access point
resource "aws_s3_access_point" "this" {
  count = var.access_points != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = var.access_points
}

# add s3 access policy
resource "aws_s3_bucket_policy" "this" {
  count = var.policy_file != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = file("${path.root}/data/${var.asset_group}_s3_policy_${var.policy_file}")
}

#  lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  count = length(var.lifecycle_rule) > 0 ? 1 : 0
  dynamic "rule" {
    for_each = var.lifecycle_rule
    content {
      id     = rule.value.id
      status = rule.value.status
      filter {
        prefix = rule.value.prefix
      }
      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}

# encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  count = length(var.server_side_encryption_configuration) > 0 ? 1 : 0
  dynamic "rule" {
    for_each = flatten([for c in var.server_side_encryption_configuration : c.rule])
    content {
      bucket_key_enabled = rule.value.bucket_key_enabled
      dynamic "apply_server_side_encryption_by_default" {
        for_each = rule.value.apply_server_side_encryption_by_default
        content {
          kms_master_key_id = apply_server_side_encryption_by_default.value.kms_master_key_id
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
        }
      }
    }
  }
}

