variable "app_name" {
  type = string
  description = "codeDeployのアプリケーション名"
}

variable "group_name" {
  type = string
  description = "サービスの名前"
}

variable "iam_role_arn" {
  type = string
  description = "IAMロールのARN"
}

variable "elb_tg_name" {
  type = string
  description = "ELBターゲットグループ名"
}
