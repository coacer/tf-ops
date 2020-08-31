variable "name" {
  type        = string
  description = "codebuildの名前"
}

variable "iam_role_arn" {
  type        = string
  description = "codebuildのIAMロールARN"
}

variable "source_bucket_name" {
  type        = string
  description = "ソースのバケット名"
}

variable "cloudfront_id" {
  type        = string
  description = "cloudfrontのディストリビューションID"
}

variable "npm_run_cmd" {
  type        = string
  description = "npmのrunコマンド"
}

variable "source_s3_region" {
  type        = string
  description = "ソースのs3リージョン"
}
