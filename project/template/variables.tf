
# 初始化 variables.tf 文件
# author := "John wang"
# https://developer.hashicorp.com/terraform/language/values/variables
variable "asset_id" {
 type = string
}
variable "asset_name" {
 type = string
}
variable "asset_area_id" {
 type = string
}
variable "asset_area_name" {
 type = string
}
variable "asset_group" {
  validation {
    condition     = contains(["dev", "staging", "cert", "prod"], var.asset_group)
    error_message = "asset_group must be dev, staging, cert, or prod."
  }
 }
variable "deployed_by" {
 type = string
}
variable "job_url" {
 type = string
}
