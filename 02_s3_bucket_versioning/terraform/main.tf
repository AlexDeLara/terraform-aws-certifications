terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "alex-de-lara"

    workspaces {
      name = "02_s3_bucket_versioning"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_hosting_bucket" {
  bucket        = local.s3_bucket
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "static_hosting_bucket_versioning" {
  bucket = aws_s3_bucket.static_hosting_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "static_hosting_bucket" {
  bucket = aws_s3_bucket.static_hosting_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_hosting_bucket" {
  bucket = aws_s3_bucket.static_hosting_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "static_hosting_html_documents" {
  for_each     = fileset(local.html_documentss_base_path, "*.html")
  bucket       = aws_s3_bucket.static_hosting_bucket.id
  key          = each.value
  source       = "${local.html_documentss_base_path}${each.value}"
  etag         = filemd5("${local.html_documentss_base_path}${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "img_version_1" {
  bucket       = aws_s3_bucket.static_hosting_bucket.id
  key          = "/img.winkie.jpg"
  source       = "${local.img_resources_base_path}/winkie.jpg"
  etag         = filemd5("${local.img_resources_base_path}/winkie.jpg")
  content_type = "image/jpeg"
  depends_on   = [aws_s3_bucket_versioning.static_hosting_bucket_versioning]
}

resource "aws_s3_object" "img_version_2" {
  bucket       = aws_s3_bucket.static_hosting_bucket.id
  key          = "/img.winkie.jpg"
  source       = "${local.img_resources_base_path}/winkie_v2.jpg"
  etag         = filemd5("${local.img_resources_base_path}/winkie.jpg")
  content_type = "image/jpeg"
  depends_on   = [aws_s3_object.img_version_1]
}
