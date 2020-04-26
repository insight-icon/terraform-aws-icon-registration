variable "create" {
  type = bool
}

variable "details_content" {}
variable "bucket_name" {}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "logo_256" {
  description = "Path to png logo"
  type        = string
  default     = ""
}
variable "logo_1024" {
  description = "Path to png logo"
  type        = string
  default     = ""
}
variable "logo_svg" {
  description = "Path to svg logo"
  type        = string
  default     = ""
}