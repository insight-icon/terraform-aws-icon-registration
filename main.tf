//data "aws_caller_identity" "this" {}
//data "aws_region" "this" {}

terraform {
  required_version = ">= 0.12"
}

resource "random_pet" "this" {
  length = 2
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"

  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

###########
# Templates
###########
resource template_file "details" {
  template = file("${path.module}/templates/details.json")
  vars = {
    //    logo_256  = var.logo_256 == "" ? "" : "http://${aws_s3_bucket.bucket.website_endpoint}/${basename(var.logo_256)}"
    //    logo_1024 = var.logo_1024 == "" ? "" : "http://${aws_s3_bucket.bucket.website_endpoint}/${basename(var.logo_1024)}"
    //    logo_svg  = var.logo_svg == "" ? "" : "http://${aws_s3_bucket.bucket.website_endpoint}/${basename(var.logo_svg)}"

    logo_256  = var.logo_256 == "" ? "" : "${local.static_endpoint}/${basename(var.logo_256)}"
    logo_1024 = var.logo_1024 == "" ? "" : "${local.static_endpoint}/${basename(var.logo_1024)}"
    logo_svg  = var.logo_svg == "" ? "" : "${local.static_endpoint}/${basename(var.logo_svg)}"

    steemit  = var.steemit
    twitter  = var.twitter
    youtube  = var.youtube
    facebook = var.facebook
    github   = var.github
    reddit   = var.reddit
    keybase  = var.keybase
    telegram = var.telegram
    wechat   = var.wechat

    country     = var.organization_country
    region      = var.organization_city
    server_type = var.server_type

    public_ip = local.public_ip
  }
}

resource "template_file" "registration" {
  template = file("${path.module}/templates/registerPRep.json")
  vars = {
    name    = var.organization_name
    country = var.organization_country
    city    = var.organization_city
    email   = var.organization_email
    website = var.organization_website

    details_endpoint = local.registration_details_endpoint

    public_ip = local.public_ip
  }
  //  depends_on = [aws_s3_bucket.this]
}

resource template_file "preptools_config" {
  template = file("${path.module}/templates/preptools_config.json")
  vars = {
    nid           = local.nid
    url           = local.url
    keystore_path = var.keystore_path
  }
  //  depends_on = [aws_s3_bucket.this]
}

#################
# Persist objects
#################
resource "local_file" "preptools_config" {
  filename = "${path.module}/preptools_config.json"
  content  = template_file.preptools_config.rendered
}

resource "local_file" "registerPRep" {
  filename = "${path.module}/registerPRep.json"
  content  = template_file.registration.rendered
}

###################
# Register / Update
###################

resource null_resource "preptools" {
  provisioner "local-exec" {
    command = <<-EOF
python ${path.module}/scripts/preptools_wrapper.py ${var.network_name} ${var.keystore_path} ${local_file.registerPRep.filename} ${var.keystore_password}
EOF
  }
  triggers = {
    build_always = timestamp()
  }
}

