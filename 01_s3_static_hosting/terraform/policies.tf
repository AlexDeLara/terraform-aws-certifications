data "aws_iam_policy_document" "static_hosting_bucket_policy" {
  statement {
    sid = "S3BucketPublicRead"

    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.static_hosting_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "static_hosting_bucket_policy" {
  bucket = aws_s3_bucket.static_hosting_bucket.id
  policy = data.aws_iam_policy_document.static_hosting_bucket_policy.json
}
