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
  //  bucket = var.bucket == "" ? "prep-registration-${random_pet.this.id}" : var.bucket
  nid = var.network_name == "testnet" ? 80 : var.network_name == "mainnet" ? 1 : ""
  url = var.network_name == "testnet" ? "https://zicon.net.solidwallet.io" : "https://ctz.solidwallet.io/api/v3"

  //  ip = var.ip == null ? join("", aws_eip.this.*.public_ip) : var.ip

  tags = merge(var.tags, { "Name" = "${var.network_name}-ip" })

  //  aws_enabled = var.cloud_provider == "aws" ? true : false

  cloud_provider          = var.cloud_provider == "" && var.public_ip != "" ? "custom" : var.cloud_provider
  static_content_provider = var.registration_details_endpoint != "" ? "custom" : var.static_content_provider == "" ? var.cloud_provider : var.static_content_provider

  bucket_name = var.bucket_name == "" ? replace(lower(var.organization_name), "/[_\\s]", "-") : var.bucket_name

  static_content_endpoints = {
    custom = var.registration_details_endpoint
    //    aws    = join("", aws_s3_bucket.this.*.website_endpoint)
    gcp = "https://storage.cloud.google.com/${local.bucket_name}"
  }

  provider_public_ips = {
    custom = var.public_ip
    //    aws    = join("", aws_eip.this.*.public_ip)
    gcp = google_compute_address.this.*.address[0]
  }

  static_endpoint               = lookup(local.static_content_endpoints, local.static_content_provider, var.website_endpoint)
  registration_details_endpoint = "${local.static_endpoint}/details.json"
  public_ip                     = lookup(local.provider_public_ips, local.cloud_provider, var.public_ip)
}
