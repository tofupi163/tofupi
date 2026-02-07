provider "aws" {
  region = var.aws_region_main
  profile = var.profile
  default_tags {
    tags = {
      AssetID       = var.asset_id
      AssetName     = var.asset_name
      AssetAreaID   = var.asset_area_id
      AssetAreaName = var.asset_area_name
      AssetGroup    = var.asset_group
      deployed_by   = var.deployed_by
      job_url       = var.job_url
    }
  }
}
