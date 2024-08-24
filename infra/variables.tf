variable "region" {
  description = "To set the region of s3"
  type        = string
  default     = "us-east-1"
}

variable "site" {
  description = "To set the region of s3"
  type        = string
  default     = "terratest-cr11"
}

variable "domain" {
  description = "domain name"
  type        = string
  default     = "cloudali.net"
}

variable "subdomain" {
  description = "sub domain name"
  type        = string
  default     = "*.cloudali.net"
}
variable "acm_cert" {
  description = "acm certificate"
  type        = string
  default     = "arn:aws:acm:us-east-1:878770078388:certificate/84c87524-a71f-4189-b5df-f788aff9138f"
}

variable "s3" {
  description = "s3 info"
  type        = string
  default     = "arn:aws:acm:us-east-1:878770078388:certificate/84c87524-a71f-4189-b5df-f788aff9138f"
}

variable "sitesource" {
  type        = string
  description = "Path to the root of website content"
  default     = "../content"
}