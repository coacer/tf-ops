resource "aws_codepipeline" "codepipeline" {
  name     = var.name
  role_arn = var.pipeline_role_arn

  artifact_store {
    location = var.pipeline_s3_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = "arn:aws:codestar-connections:ap-northeast-1:956670904611:connection/462de02d-9732-489f-bbde-d1e854a69d60",
        FullRepositoryId = var.source_repo,
        BranchName = var.service,
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = var.build_name
      }
    }
  }

}

resource "aws_codestarnotifications_notification_rule" "pipeline" {
  detail_type    = "FULL"
  event_type_ids = [
    "codepipeline-pipeline-stage-execution-started",
    "codepipeline-pipeline-stage-execution-succeeded",
    "codepipeline-pipeline-stage-execution-resumed",
    "codepipeline-pipeline-stage-execution-canceled",
    "codepipeline-pipeline-stage-execution-failed",
  ]

  name     = "ucc-front-pipeline-notification-${var.service}"
  resource = aws_codepipeline.codepipeline.arn

  target {
    address = var.sns_arn
  }
}
