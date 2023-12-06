#The S3 bucket holds the HTML, js, and css files that drive the front end.
resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.host_name}.${var.dns_zone}"
}

#The static website configuration for the bucket
resource "aws_s3_bucket_website_configuration" "website_bucket_webconfig" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#Allow public access to the bucket
resource "aws_s3_bucket_public_access_block" "website_bucket_publicaccesspolicy" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Create a bucket policy to allow anonymous/public read access
data "aws_iam_policy_document" "website_bucket_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.website_bucket.arn,
      "${aws_s3_bucket.website_bucket.arn}/*"
    ]
  }
}

#Bind the policy to the bucket
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket_policy_document.json
}

#Copy the frontend files into the S3 bucket
resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("../frontend", "**")

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "../frontend/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("../frontend/${each.value}")
}
