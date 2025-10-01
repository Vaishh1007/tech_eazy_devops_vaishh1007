provider "aws" {
  region = var.region
}

# S3 bucket
resource "aws_s3_bucket" "assignment3_bucket" {
  bucket = "${var.bucket_name}-${var.stage}"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "assignment3_lifecycle" {
  bucket = aws_s3_bucket.assignment3_bucket.id

  rule {
    id     = "expire-logs"
    status = "Enabled"

    expiration {
      days = 7
    }

    filter {
      prefix = "logs/"
    }
  }
}

# IAM Roles
resource "aws_iam_role" "s3_upload_role" {
  name = "Assignment3-S3Upload-${var.stage}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "s3_upload_policy" {
  name        = "Assignment3-S3UploadPolicy-${var.stage}"
  description = "Allow upload-only access to bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:CreateBucket", "s3:PutObject"]
      Resource = [
        aws_s3_bucket.assignment3_bucket.arn,
        "${aws_s3_bucket.assignment3_bucket.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_upload" {
  role       = aws_iam_role.s3_upload_role.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

resource "aws_iam_instance_profile" "upload_profile" {
  name = "Assignment3-InstanceProfile-${var.stage}"
  role = aws_iam_role.s3_upload_role.name
}

# EC2 Instance
resource "aws_instance" "assignment3_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.upload_profile.name

  tags = {
    Name  = "Assignment3-Instance-${var.stage}"
    Stage = var.stage
  }

  user_data = file("${path.module}/../scripts/user_data.sh")
}
