module "acm" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> 4.0"
  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.domain.zone_id
  tags        = var.tags
  subject_alternative_names = ["*.${var.domain_name}"]

  providers = {
    aws = aws.us-east-1
  }
}

resource "aws_s3_bucket" "spa" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_cors_configuration" "spa_cors" {
  bucket = aws_s3_bucket.spa.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_ownership_controls" "spa_ownership" {
  bucket = aws_s3_bucket.spa.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "spa" {
  depends_on = [aws_s3_bucket_ownership_controls.spa_ownership]

  bucket = aws_s3_bucket.spa.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "spa_encryption" {
  bucket = aws_s3_bucket.spa.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3block" {
  bucket                  = aws_s3_bucket.spa.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_function" "fn" {
  name    = "spa_fn"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/functionToAddHeaders.js")
}

resource "aws_cloudfront_distribution" "cf" {
  enabled             = true
  aliases             = [var.endpoint]
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  http_version        = "http2and3"

  origin {
    domain_name = aws_s3_bucket.spa.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.spa.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }


 custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 0
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = aws_s3_bucket.spa.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 3600
    default_ttl            = 604800
    max_ttl                = 31556952
    function_association {
      event_type = "viewer-response"
      function_arn = aws_cloudfront_function.fn.arn
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.endpoint}"
}

resource "aws_s3_bucket_policy" "s3policy" {
  bucket = aws_s3_bucket.spa.id
  policy = data.aws_iam_policy_document.s3policy.json
}

resource "aws_route53_record" "ipv4" {
  provider                  = aws.us-east-1
  name                      = var.endpoint
  zone_id                   = data.aws_route53_zone.domain.zone_id
  type                      = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ipv6" {
  provider    = aws.us-east-1
  zone_id     = data.aws_route53_zone.domain.zone_id
  name        = var.endpoint
  type        = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = false
  }
}
