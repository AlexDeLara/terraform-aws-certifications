output "static_hosting_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket.website_endpoint
}
