## route 53
resource "aws_route53_zone" "main" {
  force_destroy = "false"
  name          = var.domain
}

resource "aws_route53_record" "root" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_route53_zone.main.zone_id
  }

  name    = var.domain
  type    = "A"
  zone_id = "${aws_route53_zone.main.zone_id}"
}

resource "aws_route53_record" "ns" {
  name    = var.domain
  records = ["ns-1052.awsdns-03.org.", "ns-1661.awsdns-15.co.uk.", "ns-563.awsdns-06.net.", "ns-93.awsdns-11.com."]
  ttl     = "172800"
  type    = "NS"
  zone_id = "${aws_route53_zone.main.zone_id}"
}

resource "aws_route53_record" "soa" {
  name    = var.domain
  records = ["ns-93.awsdns-11.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl     = "900"
  type    = "SOA"
  zone_id = "${aws_route53_zone.main.zone_id}"
}

## Cloudfront
resource "aws_cloudfront_distribution" "cdn" {
  aliases = [var.domain]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = "true"
    default_ttl            = "0"
    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "${var.site}.s3.${var.region}.amazonaws.com"
    viewer_protocol_policy = "https-only"
  }

  default_root_object = "index.html"
  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"
    domain_name         = "${var.site}.s3.${var.region}.amazonaws.com"
    origin_id           = "${var.site}.s3.${var.region}.amazonaws.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert1.arn
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
## ACM
resource "aws_acm_certificate" "cert1" {
  domain_name = var.domain

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  validation_method = "DNS"
}

resource "aws_acm_certificate" "cert2" {
  domain_name = "*.${var.domain}"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  tags = {
    project = "cloud resume"
  }

  tags_all = {
    project = "cloud resume"
  }

  validation_method = "DNS"
}

## s3



resource "aws_s3_bucket" "site" {
  bucket        = var.site
  force_destroy = "true"
}

resource "aws_s3_bucket_acl" "siteacl" {
  bucket = aws_s3_bucket.site.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "siteaclacl-ownership" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
  # Add just this depends_on condition
  depends_on = [aws_s3_bucket_acl.siteacl]
}


## upload content

resource "aws_s3_bucket_object" "file" {
  depends_on = [aws_s3_bucket.site]
  for_each = fileset(var.sitesource, "**")

  bucket      = var.site
  key         = each.key
  source      = "${var.sitesource}/${each.key}"
  source_hash = filemd5("${var.sitesource}/${each.key}")
  acl         = "public-read"
}
