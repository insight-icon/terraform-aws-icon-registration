data "aws_region" "this" {}

terraform {
  required_version = ">= 0.12"
}

resource "random_pet" "this" {
  length = 2
}

locals {
  tags            = merge(var.tags, { "Name" = "${var.network_name}-ip" })
  bucket_name     = var.bucket_name == "" ? replace(lower(var.organization_name), "/[_\\s]", "-") : var.bucket_name
  static_endpoint = var.details_endpoint == "" ? "https://${join("", aws_s3_bucket.this.*.website_endpoint)}/details.json" : var.details_endpoint
}

module "registration" {
  source = "github.com/insight-icon/terraform-icon-registration.git?ref=master"

  public_ip       = var.public_ip == "" ? join("", aws_eip.this.*.public_ip) : var.public_ip
  static_endpoint = local.static_endpoint
  network_name    = var.network_name

  keystore_path     = var.keystore_path
  keystore_password = var.keystore_password

  organization_name    = var.organization_name
  organization_country = var.organization_country
  organization_email   = var.organization_email
  organization_city    = var.organization_city
  organization_website = var.organization_website

  logo_256  = var.logo_256
  logo_1024 = var.logo_1024
  logo_svg  = var.logo_svg

  steemit  = var.steemit
  twitter  = var.twitter
  youtube  = var.youtube
  facebook = var.facebook
  github   = var.github
  reddit   = var.reddit
  keybase  = var.keybase
  telegram = var.telegram
  wechat   = var.wechat

  server_type = var.server_type
}

