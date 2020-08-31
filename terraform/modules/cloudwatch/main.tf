resource "aws_cloudwatch_event_rule" "event_codepipeline" {
  name = "codepipeline-notifications-rule"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Stage Execution State Change"
  ],
  "detail": {
    "state": ["STARTED", "SUCCEEDED", "FAILED"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "event_codepipeline_target" {
  rule      = aws_cloudwatch_event_rule.event_codepipeline.name
  target_id = "SendToSNS"
  arn       = var.sns_topic_arn
}
