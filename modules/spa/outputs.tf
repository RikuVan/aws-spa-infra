output "s3_bucket_regional_name" {
    value = aws_s3_bucket.spa.bucket_regional_domain_name
}

output "bucket_name" {
    value = aws_s3_bucket.spa.bucket
}