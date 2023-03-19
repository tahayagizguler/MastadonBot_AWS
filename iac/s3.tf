resource "aws_s3_bucket" "framebucket" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true
}


resource "aws_s3_bucket_object" "frames" {
for_each = fileset("${path.module}/frames", "**/*.*")
bucket = var.bucket_name
key = each.value
source = "${path.module}/frames/${each.value}"
etag = filemd5("${path.module}/frames/${each.value}")
}

