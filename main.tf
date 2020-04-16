data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

resource "random_pet" "this" {
  length = 2
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

    logo_256  = var.logo_256 == "" ? "" : "http://${local.website_endpoint}/${basename(var.logo_256)}"
    logo_1024 = var.logo_1024 == "" ? "" : "http://${local.website_endpoint}/${basename(var.logo_1024)}"
    logo_svg  = var.logo_svg == "" ? "" : "http://${local.website_endpoint}/${basename(var.logo_svg)}"

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

    ip = local.ip
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

    details_endpoint = "http://${local.website_endpoint}/details.json"

    ip = local.ip
  }
  depends_on = [aws_s3_bucket.bucket]
}

resource template_file "preptools_config" {
  template = file("${path.module}/templates/preptools_config.json")
  vars = {
    nid           = local.nid
    url           = local.url
    keystore_path = var.keystore_path
  }
  depends_on = [aws_s3_bucket.bucket]
}


###################
# Register / Update
###################

resource null_resource "preptools" {
  provisioner "local-exec" {
    command = <<-EOF
python ${path.module}/scripts/preptools_wrapper.py ${var.network_name} ${var.keystore_path} ${path.module}/registerPRep.json ${var.keystore_password}
EOF
  }
  triggers = {
    build_always = timestamp()
  }

  depends_on = [aws_s3_bucket_object.details, local_file.preptools_config, local_file.registerPRep]
}

