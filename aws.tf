resource "aws_eip" "this" {
  count = local.cloud_provider == "aws" ? 1 : 0
  vpc   = true
  tags  = local.tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "this" {
  count = local.static_content_provider == "aws" ? 1 : 0

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
  count  = var.logo_256 != "" && local.static_content_provider == "aws" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_256)
  source = var.logo_256
}

resource "aws_s3_bucket_object" "logo_1024" {
  count  = var.logo_1024 != "" && local.static_content_provider == "aws" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_1024)
  source = var.logo_1024
}

resource aws_s3_bucket_object "logo_svg" {
  count  = var.logo_svg != "" && local.static_content_provider == "aws" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_svg)
  source = var.logo_svg
}


