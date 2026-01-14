output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`."
}

output "bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "Globally unique name of the bucket"

}

output "aws_s3_bucket" {
  value       = aws_s3_bucket.this
  description = "All exported attributes from the native terraform resource."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "Bucket domain name in format `bucketname.s3.amazonaws.com`."
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "Region specific domain name. Used for Cloudfront CDN region specific endpoint when creating an s3 origin."
}
