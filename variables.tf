variable "bucket" {
  description = "The name of the bucket to make"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "mainnet or testnet - Don't mess this up!!!!!!!!"
  type        = string
  default     = "mainnet"
}

variable "tags" {
  description = "Additional tags to include"
  type        = map(string)
  default     = {}
}

// ------------------Registration

variable "organization_name" {
  description = "Any string - your team name"
  type        = string
  default     = ""
}
variable "organization_country" {
  description = "This needs to be three letter country code per https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3"
  type        = string
  default     = ""
}
variable "organization_email" {
  description = "Needs to be real email"
  type        = string
  default     = ""
}
variable "organization_city" {
  description = "No qualifiers"
  type        = string
  default     = ""
}
variable "organization_website" {
  description = "Needs to begin in https / http - can be google..."
  type        = string
  default     = ""
}

// ------------------Details

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
variable "steemit" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "twitter" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "youtube" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "facebook" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "github" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "reddit" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "keybase" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "telegram" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "wechat" {
  description = "Link to social media account - https://..."
  type        = string
  default     = ""
}
variable "server_type" {
  description = "Link to social media account - https://..."
  type        = string
  default     = "cloud"
}

variable "region" {
  description = "The region you are running your server - no constraints"
  type        = string
  default     = ""
}

variable "ip" {
  description = "Optional if you are registering an IP from a different network"
  type        = string
  default     = null
}

//------------------

variable "keystore_path" {
  description = "the path to your keystore"
  type        = string
}

variable "keystore_password" {
  description = "The keystore password"
  type        = string
}