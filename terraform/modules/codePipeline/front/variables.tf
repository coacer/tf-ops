variable "name" {
  type        = string
  description = "codepipeline名"
}

variable "pipeline_role_arn" {
  type        = string
  description = "codepipelineのロールARN"
}

variable "pipeline_s3_bucket" {
  type        = string
  description = "codepipelineのs3バケット名"
}

variable "source_repo" {
  type        = string
  description = "codepipelineのソースリポジトリ名"
}

variable "service" {
  type        = string
  description = "サービス名"
}

variable "build_name" {
  type        = string
  description = "codebuild名"
}

variable "sns_arn" {
  type        = string
  description = "通知用SNSトピックのARN"
}
