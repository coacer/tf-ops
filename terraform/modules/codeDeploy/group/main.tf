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

  # elbトラフィック制御(試験段階はパイプラインの時間が長くなってしまうので無効化)
  # deployment_style {
  #   deployment_option = "WITH_TRAFFIC_CONTROL"
  # }
  #
  # load_balancer_info {
  #   target_group_info {
  #     name = var.elb_tg_name
  #   }
  # }

}
