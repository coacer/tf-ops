output "app_name" {
  value = aws_codedeploy_deployment_group.deploy_group.app_name
}

output "group_name" {
  value = aws_codedeploy_deployment_group.deploy_group.deployment_group_name
}
