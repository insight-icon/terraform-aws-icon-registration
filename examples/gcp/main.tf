provider "google" {
  //  project = var.gcp_project
  region      = var.gcp_region
  credentials = file("/home/rob/cloud/gcp/polkadot-testing-a323ef67f7d9.json")
}

provider "google-beta" {
  //  project = var.gcp_project
  region = var.gcp_region
}

variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_project" {
  default = "polkadot-testing"
}

//provider "google" {
//  project = var.gcp_project
//  region  = var.gcp_region
//}

locals {
  keystore_path = var.keystore_path == "" ? "${path.cwd}/../../test/fixtures/keystore/testnet" : var.keystore_path
  logo_256      = var.logo_256 == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_256
  logo_1024     = var.logo_1024 == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_1024
  logo_svg      = var.logo_svg == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_svg
}

module "defaults" {
  source = "../.."

  gcp_project_name = var.gcp_project_name
  cloud_provider   = "gcp"

  network_name = "testnet"

  organization_name    = "Insight-CI"
  organization_country = "USA"
  organization_email   = "hunter@gmail.com"
  organization_city    = "A city"
  organization_website = "https://google.com"

  server_type = "cloud"
  //  region = "us-east-1"

  keystore_password = var.keystore_password
  keystore_path     = local.keystore_path

  logo_256  = local.logo_256
  logo_1024 = local.logo_1024

  logo_svg = local.logo_svg
}
