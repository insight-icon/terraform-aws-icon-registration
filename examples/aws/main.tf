
variable "logo_256" {
  default = ""
}

variable "logo_1024" {
  default = ""
}

variable "logo_svg" {
  default = ""
}

variable "keystore_path" {
  default = ""
}

variable "keystore_password" {
  default = "testing1."
}

locals {
  keystore_path = var.keystore_path == "" ? "${path.cwd}/../../test/fixtures/keystore/testnet" : var.keystore_path
  logo_256      = var.logo_256 == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_256
  logo_1024     = var.logo_1024 == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_1024
  logo_svg      = var.logo_svg == "" ? "${path.cwd}/../../test/fixtures/logos/insight.png" : var.logo_svg
}

module "defaults" {
  source = "../.."

  network_name = "testnet"

  organization_name    = "Insight-CI"
  organization_country = "USA"
  # This needs to be three letter country code per https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
  organization_email = "hunter@gmail.com"
  # Needs to be real email
  organization_city = "A city"
  # No qualifiers
  organization_website = "https://google.com"
  # Needs to begin in https / http - can be google...

  // All the logos are complete paths to the image on your local drive
  //  logo_256 = "/Users/.../logo_256"
  //  logo_1024 = "/Users/.../logo_1024"
  //  logo_svg = "/Users/.../logo_svg"

  // If you have already have an IP, you can enter it here / uncomment and a new IP will not be provisioned with the
  // existing IP being brought
  //  ip = "1.2.3.4"
  // ------------------Details - Doesn't really matter
  server_type = "cloud"
  //  region      = "us-east-1"

  keystore_password = var.keystore_password
  keystore_path     = local.keystore_path

  logo_256  = local.logo_256
  logo_1024 = local.logo_1024

  logo_svg = local.logo_svg
}
