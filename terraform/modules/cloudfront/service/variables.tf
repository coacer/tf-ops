variable "origin_name" {
  type = string
  description = "バケット名"
}

variable "origin_domain_name" {
  type = string
  description = "バケットリージョンドメイン名"
}

variable "origin_access_identity_id" {
  type = string
  description = "OriginAccessIdentityのID"
}

variable "comment" {
  type = string
  description = "コメント"
}

variable "aliases" {
  type = list(string)
  description = "Alternate Domain Names (CNAMEs)"
}

variable "acm_arn" {
  type = string
  description = "ACMのARN"
}
