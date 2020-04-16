
data "google_client_config" "current" {
  count = local.cloud_provider == "gcp" || local.static_content_provider == "gcp" ? 1 : 0
}

variable "gcp_project_name" {
  description = "The display name of the gcp project to create - required for cloud / content provider = gcp"
  type        = string
  default     = ""
}

variable "gcp_project_id" {
  description = "The name of the gcp project to create - required for cloud / content provider = gcp"
  type        = string
  default     = ""
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

resource "google_project" "this" {
  count      = local.cloud_provider == "gcp" || local.static_content_provider ? 1 : 0
  name       = var.gcp_project_name
  project_id = var.gcp_project_id
}

resource "google_compute_address" "this" {
  name = "main-ip-${join("", google_project.this.*.name)}"
}

resource "google_storage_bucket" "this" {
  count = local.static_content_provider == "gcp" ? 1 : 0

  provider = google-beta

  project = join("", google_project.this.*.name)

  name          = "icon-details-${join("", data.google_client_config.current.*.project)}"
  location      = var.gcp_website_location
  storage_class = var.gcp_website_storage_class

  versioning {
    enabled = true
  }

  labels = values(module.label.tags)
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
  name   = "logo_256.png"
}

resource "google_storage_bucket_object" "logo_1024" {
  count = var.logo_1024 != "" && local.static_content_provider == "gcp" ? 1 : 0

  bucket = join("", google_storage_bucket.this.*.id)
  name   = "logo_1024.png"
}

resource "google_storage_bucket_object" "logo_svg" {
  count = var.logo_svg != "" && local.static_content_provider == "gcp" ? 1 : 0

  bucket = join("", google_storage_bucket.this.*.id)
  name   = "logo_svg.png"
}

