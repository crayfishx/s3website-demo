output "endpoint" {
  description = "S3 Endpoint URL"
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_domain" {
  description = "S3 website domain"
  value = aws_s3_bucket_website_configuration.website.website_domain
}
