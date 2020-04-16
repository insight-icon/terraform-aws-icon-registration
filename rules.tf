variable "cloud_provider" {
  description = "The cloud procider you are running on"
  type        = string
  default     = "aws"
}

locals {
  region = var.region == "" ? data.aws_region.this.name : var.region
  bucket = var.bucket == "" ? "prep-registration-${random_pet.this.id}" : var.bucket
  nid    = var.network_name == "testnet" ? 80 : var.network_name == "mainnet" ? 1 : ""
  url    = var.network_name == "testnet" ? "https://zicon.net.solidwallet.io" : "https://ctz.solidwallet.io/api/v3"

  ip = var.ip == null ? join("", aws_eip.this.*.public_ip) : var.ip

  tags = merge(var.tags, { "Name" = "${var.network_name}-ip" })

  aws_enabled = var.cloud_provider == "aws" ? true : false

  website_endpoint = local.aws_enabled ? join("", aws_s3_bucket.bucket.*.website_endpoint) : ""
  public_ip        = local.aws_enabled ? join("", aws_eip.this.*.public_ip) : var.ip
}

