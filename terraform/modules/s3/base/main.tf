resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.codepipeline_bucket
  acl    = "private"
}
