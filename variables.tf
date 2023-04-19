variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the acm certificate."
}
variable "route53_zone_id" {
  type        = string
  description = "ID of the route53 zone."
}
