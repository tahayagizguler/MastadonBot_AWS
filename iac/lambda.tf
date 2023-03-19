# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/myfunc/package"
#   output_path = "${local.deployment_zip_file}"
# }

# resource "aws_s3_object" "func" {
#   bucket = aws_s3_bucket.framebucket.id

#   key    = "my-deployment-package.zip"
#   source = data.archive_file.lambda_zip.output_path

#   etag = filemd5(data.archive_file.lambda_zip.output_path)
# }

//Define lambda function
resource "aws_lambda_function" "lambda_mastadon" {
  filename    = "${path.module}/my-deployment-package.zip"
  function_name = "lambdaFunc"

  # s3_bucket = aws_s3_bucket.framebucket.id
  # s3_key    = aws_s3_object.func.key

  runtime = "python3.9"
  handler = "lambda_function.lambda_handler"

  # source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  timeout = 60  

} 

resource "aws_iam_role" "lambda_exec" {
  name_prefix = "LambdaExecCW"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_access_policy" {
  name_prefix = "ssm_access_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = "arn:aws:ssm:us-east-1:815717162668:parameter/my_consumer_key" # Change your access token arn!
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_access_policy_attachment" {
  policy_arn = aws_iam_policy.ssm_access_policy.arn
  role       = aws_iam_role.lambda_exec.name
}

resource "aws_iam_policy" "s3_access_policy" {
  name_prefix = "s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
        ],
        Resource = [
          "arn:aws:s3:::taxidriverframes", # Replace with your own bucket name!
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
        ],
        Resource = [
          "arn:aws:s3:::taxidriverframes/*", # # Replace with your own bucket name!
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.lambda_exec.name
}
