output "cloudfront_url" {
  description = "The domain name of the CloudFront distribution."
  value       = "https://${aws_cloudfront_distribution.cv.domain_name}"
}
