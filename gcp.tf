
variable "gcp_project_name" {
  description = "The display name of the gcp project to create - required for cloud / content provider = gcp"
  type        = string
  default     = "icon-testing"
}

variable "gcp_project_id" {
  description = "The name of the gcp project to create - required for cloud / content provider = gcp"
  type        = string
  default     = "icon-testing"
}

variable "gcp_website_location" {
  description = "(Optional, Default: 'US') The GCS location"
  type        = string
  default     = "US"
}

variable "gcp_website_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE"
  type        = string
  default     = "STANDARD"
}

locals {
  gcp_project_name = var.gcp_project_name == "" ? module.label.name : var.gcp_project_name
  gcp_project_id   = var.gcp_project_id == "" ? trim(module.label.name, "-") : var.gcp_project_name
}

data "google_client_config" "current" {
  count = local.cloud_provider == "gcp" || local.static_content_provider == "gcp" ? 1 : 0
}

output "name" {
  value = module.label.name
}

resource "google_compute_address" "this" {
  count = local.cloud_provider == "gcp" ? 1 : 0

  //  name = "main-ip-${join("", google_project.this.*.name)}"
  //  name = join("", google_project.this.*.id)
  //  name = join("", data.google_client_config.current.*.id)
  name = "main-ip"
}

resource "google_storage_bucket" "this" {
  count = local.static_content_provider == "gcp" ? 1 : 0

  //  provider = google-beta

  //  project = join("", google_project.this.*.name)

  //  name          = "icon-details-${join("", data.google_client_config.current.*.project)}"
  name = local.bucket_name
  //  location      = var.gcp_website_location
  location = "US"
  //  storage_class = var.gcp_website_storage_class

  force_destroy = true

  versioning {
    enabled = true
  }

  //  labels = module.label.tags
}

resource "google_storage_default_object_acl" "website_acl" {
  count = local.static_content_provider == "gcp" ? 1 : 0

  provider    = google-beta
  bucket      = join("", google_storage_bucket.this.*.id)
  role_entity = ["READER:allUsers"]
}

resource "google_storage_bucket_object" "logo_256" {
  count = var.logo_256 != "" && local.static_content_provider == "gcp" ? 1 : 0

  bucket = join("", google_storage_bucket.this.*.id)
  name   = basename(var.logo_256)
  source = var.logo_256
}

resource "google_storage_bucket_object" "logo_1024" {
  count = var.logo_1024 != "" && local.static_content_provider == "gcp" ? 1 : 0

  bucket = join("", google_storage_bucket.this.*.id)
  name   = basename(var.logo_1024)
  source = var.logo_1024
}

resource "google_storage_bucket_object" "logo_svg" {
  count = var.logo_svg != "" && local.static_content_provider == "gcp" ? 1 : 0

  bucket = join("", google_storage_bucket.this.*.id)
  name   = basename(var.logo_svg)
  source = var.logo_256
}

resource "google_storage_bucket_object" "details_json" {
  count = local.static_content_provider == "gcp" ? 1 : 0

  bucket  = join("", google_storage_bucket.this.*.id)
  name    = "details.json"
  content = template_file.details.rendered
}

//resource "aws_s3_bucket_object" "details" {
//  count = local.static_content_provider == "aws" ? 1 : 0
//
//  bucket  = join("", aws_s3_bucket.this.*.bucket)
//  key     = "details.json"
//}
