# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/ephemeral-resources/ssm_parameter
locals {
  full_name = "/${var.asset_id}/${var.short_name}/${var.asset_group}"
}

resource "aws_ssm_parameter" "this" {
  name = var.name != null ? var.name : local.full_name
  lifecycle {
    prevent_destroy = true
  }
  arn  = "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter${var.name != null ? var.name : local.full_name}"
  type = var.type
  value = var.value_file != null ? file("${path.root}/data/${var.asset_group}_ssm_${var.value_file}") : var.value
  tags = var.tags != null ? {
    for k, v in var.tags : k => v
  } : {}
}
