resource "aws_s3_bucket" "website" {
    bucket = "site-${var.sitename}-${var.environment}-html"
    tags = {
        Environment = var.environment
    }
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
        }
      ]
    }
  )
  depends_on = [ aws_s3_bucket_acl.website ]
}


resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key = "index.html"
  source = "site/index.html"
  content_type = "text/html"
  etag = filemd5("site/index.html")
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
}
