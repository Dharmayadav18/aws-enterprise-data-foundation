output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "curated_bucket" {
  value = aws_s3_bucket.curated.bucket
}

output "publish_bucket" {
  value = aws_s3_bucket.publish.bucket
}

output "sns_topic" {
  value = aws_sns_topic.batch_alerts.arn
}
