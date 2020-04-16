variable "cloud_provider" {
  description = "The cloud procider you are running on"
  type        = string
  default     = "aws"
}

variable "website_endpoint" {
  description = "Endpoint you keep your details on - empty to create"
  type        = string
  default     = ""
}

variable "registration_details_endpoint" {
  description = "the endpoint with the details for registration - leave empty to default to cloud provider"
  type        = string
  default     = ""
}

locals {
  //  region = var.region == "" ? data.aws_region.this.name : var.region
  bucket = var.bucket == "" ? "prep-registration-${random_pet.this.id}" : var.bucket
  nid    = var.network_name == "testnet" ? 80 : var.network_name == "mainnet" ? 1 : ""
  url    = var.network_name == "testnet" ? "https://zicon.net.solidwallet.io" : "https://ctz.solidwallet.io/api/v3"

  //  ip = var.ip == null ? join("", aws_eip.this.*.public_ip) : var.ip

  tags = merge(var.tags, { "Name" = "${var.network_name}-ip" })

  aws_enabled = var.cloud_provider == "aws" ? true : false

  static_content_provider = var.static_content_provider == "" && var.registration_details_endpoint == "" ? var.cloud_provider : "custom"
  cloud_provider          = var.cloud_provider == "" && var.public_ip == "" ? var.cloud_provider : "custom"

  static_content_endpoints = {
    custom = var.registration_details_endpoint
    aws    = join("", aws_s3_bucket.this.*.website_endpoint)
    gcp    = join("", google_storage_bucket.this.website)
  }

  provider_public_ips = {
    custom = var.public_ip
    aws    = join("", aws_eip.this.*.public_ip)
  }

  registration_details_endpoint = lookup(local.static_content_endpoints, var.cloud_provider, var.website_endpoint)
  public_ip                     = lookup(local.static_content_endpoints, var.cloud_provider, var.public_ip)
}

