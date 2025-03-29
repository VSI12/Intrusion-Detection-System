output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.upload_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.upload_bucket.arn
}