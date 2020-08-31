resource "aws_codebuild_project" "codebuild" {
  name          = var.name
  build_timeout = "15"
  service_role  = var.iam_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_S3_HOST_BUCKET_NAME"
      value = var.source_bucket_name
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_CLOUDFRONT_DISTRIBUTION_ID"
      value = var.cloudfront_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "NPM_RUN_COMMAND"
      value = var.npm_run_cmd
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_S3_HOST_REGION"
      value = var.source_s3_region
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
