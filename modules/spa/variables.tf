variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "endpoint" {
  description = "Endpoint url"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "allowed_methods" {
  type        = list
  description = "Cloudfront default cache behavior allowed methods"
  default     = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
}

variable "cached_methods" {
  type        = list
  description = "Cloudfront default cache behavior cached methods"
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "tags" {
  type        = map
  description = "AWS resource tags"
  default     = {}
}

variable region {
  description = "AWS region"
  type        = string
}