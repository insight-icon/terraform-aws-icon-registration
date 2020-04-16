resource "aws_eip" "this" {
  count = var.ip == null && local.aws_enabled ? 1 : 0
  vpc   = true
  tags  = local.tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "bucket" {
  count = local.aws_enabled ? 1 : 0

  bucket = local.bucket
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.bucket}/*",
      "Principal": "*"
    }
  ]
}
EOF
}

########
# Images
########
resource "aws_s3_bucket_object" "logo_256" {
  count  = var.logo_256 != "" && local.aws_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.bucket.*.bucket)
  key    = basename(var.logo_256)
  source = var.logo_256
}

resource "aws_s3_bucket_object" "logo_1024" {
  count  = var.logo_1024 != "" && local.aws_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.bucket.*.bucket)
  key    = basename(var.logo_1024)
  source = var.logo_1024
}

resource aws_s3_bucket_object "logo_svg" {
  count  = var.logo_svg != "" && local.aws_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.bucket.*.bucket)
  key    = basename(var.logo_svg)
  source = var.logo_svg
}


#################
# Persist objects
#################
resource "local_file" "preptools_config" {
  count = local.aws_enabled ? 1 : 0

  filename = "${path.module}/preptools_config.json"
  content  = template_file.preptools_config.rendered
}

resource "local_file" "registerPRep" {
  count = local.aws_enabled ? 1 : 0

  filename = "${path.module}/registerPRep.json"
  content  = template_file.registration.rendered
}

resource "aws_s3_bucket_object" "details" {
  count = local.aws_enabled ? 1 : 0

  bucket  = join("", aws_s3_bucket.bucket.*.bucket)
  key     = "details.json"
  content = template_file.details.rendered
}