provider "aws" {
  version = "3.3.0"
  region  = "ap-northeast-1"
  profile = "myadmin"
}

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket  = "terraform-ucc"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "myadmin"
  }
}

data "aws_acm_certificate" "default" {
  domain = "*.coacerucc.work"
}

module "ec2_1" {
  source               = "../modules/ec2"
  name                 = "ucc-test-prd"
  app_subnet_id        = module.vpc.subnet-1a_id
  app_sg_id            = module.vpc.app_sg_id
  iam_instance_profile = module.iam.instance_profile
}

module "ec2_2" {
  source               = "../modules/ec2"
  name                 = "ucc-test-prd"
  app_subnet_id        = module.vpc.subnet-1c_id
  app_sg_id            = module.vpc.app_sg_id
  iam_instance_profile = module.iam.instance_profile
}

module "vpc" {
  source     = "../modules/vpc"
  app_ec2_1_id = module.ec2_1.app_id
  app_ec2_2_id = module.ec2_2.app_id
}

module "codeDeployApp" {
  source   = "../modules/codeDeploy/app"
  app_name = "ucc-app"
}

module "sns" {
  source     = "../modules/sns"
  name       = "ucc-sns"
  account_id = "956670904611"
}

module "s3" {
  source              = "../modules/s3/base"
  codepipeline_bucket = "ucc-codepipeline"
}

module "iam" {
  source                  = "../modules/iam"
  codepipeline_bucket_arn = module.s3.codepipeline_bucket_arn
  front_source_bucket_prefix = "ucc-front-"
}

module "cloudfront_access_identity" {
  source  = "../modules/cloudfront/base"
  comment = "ucc-access-identity"
}

module "elb" {
  source          = "../modules/elb"
  name            = "ucc-app"
  security_groups = [module.vpc.elb_sg_id]
  subnets         = [module.vpc.subnet-1a_id, module.vpc.subnet-1c_id]
  vpc_id          = module.vpc.vpc_id
  ec2_1_id        = module.ec2_1.app_id
  ec2_2_id        = module.ec2_2.app_id
  acm_arn         = data.aws_acm_certificate.default.arn
}

# module "cloudwatch" {
#   source = "../modules/cloudwatch"
#   sns_topic_arn = module.sns.sns_topic_arn
# }
