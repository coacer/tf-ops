resource "aws_codedeploy_deployment_group" "deploy_group" {
  app_name              = var.app_name
  deployment_group_name = var.group_name
  service_role_arn      = var.iam_role_arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "env"
      type  = "KEY_AND_VALUE"
      value = "prd"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
