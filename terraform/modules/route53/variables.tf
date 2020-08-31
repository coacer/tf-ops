variable "zone_id" {
  type        = string
  description = "Route53のゾーンID"
}

variable "subdomain" {
  type        = string
  description = "サブドメイン"
}

variable "dns_name" {
  type        = string
  description = "DNS名"
}

variable "hosted_zone_id" {
  type        = string
  description = "ホストのゾーンID"
}

