variable "name" {
  type = string
  description = "name"
}

variable "security_groups" {
  type = list(string)
  description = "セキュリティグループ"
}

variable "subnets" {
  type = list(string)
  description = "サブネット"
}

variable "vpc_id" {
  type = string
  description = "VPCのID"
}

variable "ec2_1_id" {
  type = string
  description = "EC2インスタンスID"
}

variable "ec2_2_id" {
  type = string
  description = "EC2インスタンスID"
}

variable "acm_arn" {
  type = string
  description = "ACMのARN"
}

