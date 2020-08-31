resource "aws_iam_role" "role_for_codedeploy" {
  name = "CodeDeployRoleForSelf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole_to_self" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.role_for_codedeploy.name
}

resource "aws_iam_role" "role_for_ec2" {
  name = "CodeDeployAndS3RoleForEc2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.role_for_ec2.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole_to_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.role_for_ec2.name
}

resource "aws_iam_role_policy" "ec2_awslogs_policy" {
  name = "AwsLogsPolicy"
  role = aws_iam_role.role_for_ec2.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_role" {
  name = "CodeDeployAndS3RoleForEc2"
  role = aws_iam_role.role_for_ec2.name
}

resource "aws_iam_role" "role_for_codepipeline" {
  name = "UCCCodePipelineRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "CodePipelineRolePolicy"
  role = aws_iam_role.role_for_codepipeline.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.codepipeline_bucket_arn}",
        "${var.codepipeline_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codestar-connections:UseConnection",
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "role_for_codebuild" {
  name = "UCCCodeBuildRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "CodeBuildRolePolicy"
  role = aws_iam_role.role_for_codebuild.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.codepipeline_bucket_arn}",
        "${var.codepipeline_bucket_arn}/*",
        "arn:aws:s3:::${var.front_source_bucket_prefix}*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "logs:CreateLogStream",
        "codebuild:UpdateReport",
        "codebuild:BatchPutCodeCoverages",
        "cloudfront:CreateInvalidation",
        "logs:CreateLogGroup",
        "logs:PutLogEvents",
        "codebuild:BatchPutTestCases"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
