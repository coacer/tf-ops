output "id" {
  value = aws_s3_bucket.front_source_bucket.id
}

output "domain_name" {
  value = aws_s3_bucket.front_source_bucket.bucket_regional_domain_name
}

output "region" {
  value = aws_s3_bucket.front_source_bucket.region
}
