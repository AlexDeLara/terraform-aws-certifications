output "static_hosting_domain" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket.website_domain
}