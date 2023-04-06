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
      prefix = "terraform-aws-certifications-"
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

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "static_hosting_html_documents" {
  for_each = fileset(local.html_documentss_base_path, "*.html")
  bucket = aws_s3_bucket.static_hosting_bucket.id
  key    = each.value
  source = "${local.html_documentss_base_path}${each.value}"
  etag = filemd5("${local.html_documentss_base_path}${each.value}")
}

resource "aws_s3_object" "static_hosting_img_resources" {
  for_each = fileset(local.img_resources_base_path, "*.jpg")
  bucket = aws_s3_bucket.static_hosting_bucket.id
  key    = "img/${each.value}"
  source = "${local.img_resources_base_path}${each.value}"
  etag = filemd5("${local.img_resources_base_path}${each.value}")
}


