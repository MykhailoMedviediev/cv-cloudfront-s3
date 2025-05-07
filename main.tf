resource "aws_s3_bucket" "cv" {
  bucket = "medviedievm-cv"

  tags = local.tags
}

resource "aws_s3_object" "cv" {
  bucket       = aws_s3_bucket.cv.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"

  tags = local.tags
}

resource "aws_cloudfront_origin_access_control" "cv" {
  name        = "cv"
  description = "OAC for CV Distribution"

  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "cv" {
  name    = "cv"
  comment = "Cache Policy for CV"

  default_ttl = 604800  # 7 days
  min_ttl     = 86400   # 1 day
  max_ttl     = 2592000 # 30 days

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    headers_config {
      header_behavior = "none"
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "cv" {
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  comment = "CV Distribution"

  tags = local.tags

  origin {
    origin_id                = local.origin_id
    domain_name              = aws_s3_bucket.cv.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cv.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id = local.origin_id

    allowed_methods = local.http_read_methods
    cached_methods  = local.http_read_methods
    cache_policy_id = aws_cloudfront_cache_policy.cv.id

    viewer_protocol_policy = "redirect-to-https"
  }
}

data "aws_iam_policy_document" "cv" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cv.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cv.arn]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "cv" {
  bucket = aws_s3_bucket.cv.id
  policy = data.aws_iam_policy_document.cv.json
}
