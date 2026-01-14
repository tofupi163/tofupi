// prevent destroy default true
variable "prevent_destroy" {
  type = bool
  default = true
}
// project specific identifiers
variable "asset_id" {
  type = string
}
variable "asset_name" {
  type = string
}

// application specific identifiers
variable "asset_area_id" {
  type = string
}
variable "asset_area_name" {
  type = string
}

// environment etc.
variable "asset_group" {
  type = string
}

variable "aws_account" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "short_name" {
  type = string
  default = ""
}

variable "name" {
  type = string
  default = null
}

variable "tags" {
  type = map(string)
  default = null
}

variable "value" {
  type = string
  default = null
}

variable "type" {
  type = string
  default = "String"
}

variable "value_file" {
  type = string
  default = null
}
