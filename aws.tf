variable "enable_testing" {
  description = "Bool for testing for lifecycle policies"
  type        = bool
  default     = false
}

resource "aws_eip" "testing" {
  count = var.public_ip == "" && var.enable_testing ? 1 : 0
  vpc   = true
  tags  = merge({ name = var.organization_name }, local.tags)

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip" "main" {
  count = var.public_ip == "" && ! var.enable_testing ? 1 : 0
  vpc   = true
  tags  = merge({ name = var.organization_name }, local.tags)

  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_s3_bucket" "this" {
  count = var.details_endpoint == "" ? 1 : 0

  bucket = local.bucket_name
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
      "Resource": "arn:aws:s3:::${local.bucket_name}/*",
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
  count  = var.logo_256 != "" && var.details_endpoint == "" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_256)
  source = var.logo_256
}

resource "aws_s3_bucket_object" "logo_1024" {
  count  = var.logo_1024 != "" && var.details_endpoint == "" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_1024)
  source = var.logo_1024
}

resource aws_s3_bucket_object "logo_svg" {
  count  = var.logo_svg != "" && var.details_endpoint == "" ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.bucket)
  key    = basename(var.logo_svg)
  source = var.logo_svg
}

resource "aws_s3_bucket_object" "details" {
  count = var.details_endpoint == "" ? 1 : 0

  bucket  = join("", aws_s3_bucket.this.*.bucket)
  key     = "details.json"
  content = module.registration.details_content
}
