variable "name" {
  type = string
  description = "ec2インスタンスのNameタグ名"
}

variable "app_subnet_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}
