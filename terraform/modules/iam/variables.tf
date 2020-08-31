variable "codepipeline_bucket_arn" {
  type = string
  description = "S3AndCodeBuildRoleForCodePipelineのアクセスバケットARN"
}

variable "front_source_bucket_prefix" {
  type = string
  description = "フロントバケットのプレフィックス"
}
