
variable "gcp_project_name" {
  description = "GCP project name"
  type        = string
  default     = "ICONtest"
}

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
