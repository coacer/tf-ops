output "role_for_codedeploy_arn" {
  value = aws_iam_role.role_for_codedeploy.arn
}

output "instance_profile" {
  value = aws_iam_instance_profile.ec2_role.name
}

output "role_for_codepipeline_arn" {
  value = aws_iam_role.role_for_codepipeline.arn
}
