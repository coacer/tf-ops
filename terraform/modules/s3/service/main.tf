resource "aws_s3_bucket" "front_source_bucket" {
  bucket = var.front_source_bucket
  acl    = "private"
  force_destroy = true

   website {
    index_document = "index.html"
    # error_document = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "front_source_bucket" {
  bucket = aws_s3_bucket.front_source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "front_source_bucket" {
  # issue(https://github.com/terraform-providers/terraform-provider-aws/issues/7628)がまだopenのため必要
  depends_on = [aws_s3_bucket_public_access_block.front_source_bucket]
  bucket = aws_s3_bucket.front_source_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.access_identity_id}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.front_source_bucket.id}/*"
        }
    ]
}
POLICY
}
