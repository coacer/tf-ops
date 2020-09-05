provider "aws" {
  version = "3.3.0"
  region  = "ap-northeast-1"
  profile = "myadmin"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "myadmin"
}

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket  = "terraform-ucc"
    key     = "service"
    region  = "ap-northeast-1"
    profile = "myadmin"
  }
}

data "aws_s3_bucket" "codepipeline" {
  bucket = "ucc-codepipeline"
}

data "aws_iam_role" "codedeploy" {
  name = "CodeDeployRoleForSelf"
}

data "aws_iam_role" "codepipeline" {
  name = "UCCCodePipelineRole"
}

data "aws_sns_topic" "sns" {
  name = "ucc-sns"
}

data "aws_iam_role" "codebuild" {
  name = "UCCCodeBuildRole"
}

data "aws_route53_zone" "route53" {
  name = "coacerucc.work"
}

data "aws_lb" "elb" {
  name = "ucc-app"
}

data "aws_lb_target_group" "elb_tg" {
  name = "ucc-app-tg"
}

data "aws_acm_certificate" "default" {
  domain = "*.www.coacerucc.work"
  provider = aws.virginia
}

module "codeDeployGroup" {
  source       = "../modules/codeDeploy/group"
  app_name     = "ucc-app"
  group_name   = terraform.workspace
  iam_role_arn = data.aws_iam_role.codedeploy.arn
  elb_tg_name  = data.aws_lb_target_group.elb_tg.name
}

module "codePipelineApp" {
  source             = "../modules/codePipeline/app"
  name               = "ucc-app-${terraform.workspace}"
  pipeline_role_arn  = data.aws_iam_role.codepipeline.arn
  pipeline_s3_bucket = data.aws_s3_bucket.codepipeline.bucket
  source_repo        = "y-nakagami/ucc-app"
  service            = terraform.workspace
  deploy_app_name    = module.codeDeployGroup.app_name
  deploy_group_name  = module.codeDeployGroup.group_name
  sns_arn            = data.aws_sns_topic.sns.arn
}

module "codePipelineFront" {
  source             = "../modules/codePipeline/front"
  name               = "ucc-front-${terraform.workspace}"
  pipeline_role_arn  = data.aws_iam_role.codepipeline.arn
  pipeline_s3_bucket = data.aws_s3_bucket.codepipeline.bucket
  source_repo        = "y-nakagami/ucc-front"
  service            = terraform.workspace
  build_name         = module.codebuild.name
  sns_arn            = data.aws_sns_topic.sns.arn
}

locals {
  access_identity_id = "EC2SBNNLQ0ILZ"
}

locals {
  front_subdomain = "${terraform.workspace}.www"
}

module "s3" {
  source             = "../modules/s3/service"
  front_source_bucket = "ucc-front-${terraform.workspace}"
  access_identity_id = local.access_identity_id
}

module "cloudfront" {
  source                    = "../modules/cloudfront/service"
  origin_name               = module.s3.id
  origin_domain_name        = module.s3.domain_name
  origin_access_identity_id = local.access_identity_id
  comment                   = terraform.workspace
  aliases                   = ["${local.front_subdomain}.coacerucc.work"]
  acm_arn                   = data.aws_acm_certificate.default.arn
}

module "codebuild" {
  source             = "../modules/codebuild"
  name               = "ucc-build-${terraform.workspace}"
  iam_role_arn       = data.aws_iam_role.codebuild.arn
  source_bucket_name = module.s3.id
  cloudfront_id      = module.cloudfront.id
  npm_run_cmd        = "build"
  source_s3_region   = module.s3.region
}

module "route53_record_app" {
  source         = "../modules/route53"
  zone_id        = data.aws_route53_zone.route53.zone_id
  subdomain      = terraform.workspace
  dns_name       = data.aws_lb.elb.dns_name
  hosted_zone_id = data.aws_lb.elb.zone_id
}

module "route53_record_front" {
  source         = "../modules/route53"
  zone_id        = data.aws_route53_zone.route53.zone_id
  subdomain      = local.front_subdomain
  dns_name       = module.cloudfront.domain_name
  hosted_zone_id = module.cloudfront.hosted_zone_id
}
