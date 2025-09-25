provider "aws" {
  region = var.region
}

# -------------------------------
# IAM ROLES
# -------------------------------

# Role A: Read-only S3
resource "aws_iam_role" "s3_readonly_role" {
  name = "Assignment2-S3ReadOnly"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "Assignment2-S3ReadOnlyPolicy"
  description = "Read-only access to S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:ListBucket", "s3:GetObject"]
      Effect   = "Allow"
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_readonly" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

# Role B: Upload-only S3
resource "aws_iam_role" "s3_upload_role" {
  name = "Assignment2-S3Upload"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "s3_upload_policy" {
  name        = "Assignment2-S3UploadPolicy"
  description = "Allow creating bucket and uploading objects (no read)"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:CreateBucket", "s3:PutObject"]
      Effect   = "Allow"
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_upload" {
  role       = aws_iam_role.s3_upload_role.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

resource "aws_iam_instance_profile" "upload_profile" {
  name = "Assignment2-InstanceProfile"
  role = aws_iam_role.s3_upload_role.name
}

# -------------------------------
# S3 BUCKET + LIFECYCLE
# -------------------------------
resource "aws_s3_bucket" "assignment2_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "assignment2_lifecycle" {
  bucket = aws_s3_bucket.assignment2_bucket.id

  rule {
    id     = "expire-logs"
    status = "Enabled"

    filter {
      prefix = "logs/"   # apply rule only to objects under logs/ path
    }

    expiration {
      days = 7
    }
  }
}


# -------------------------------
# EC2 INSTANCE
# -------------------------------
resource "aws_instance" "assignment2_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.upload_profile.name

  tags = {
    Name = "Assignment2-Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y awscli docker git
              systemctl start docker
              systemctl enable docker

              # Create app logs dir
              mkdir -p /app/logs
              echo "App started on $(date)" >> /app/logs/app.log

              # Shutdown script to upload logs
              cat << 'EOT' > /usr/local/bin/upload-logs.sh
              #!/bin/bash
              aws s3 cp /var/log/cloud-init.log s3://${var.bucket_name}/system/
              aws s3 cp /app/logs/ s3://${var.bucket_name}/app/ --recursive
              EOT

              chmod +x /usr/local/bin/upload-logs.sh

              # Register shutdown script
              echo "@reboot root /usr/local/bin/upload-logs.sh" >> /etc/crontab
              echo "@reboot root /usr/local/bin/upload-logs.sh" >> /etc/crontab
              EOF
}

# -------------------------------
# VERIFY with Role A (Optional)
# -------------------------------
resource "null_resource" "verify_s3_readonly" {
  provisioner "local-exec" {
    command = "aws sts assume-role --role-arn ${aws_iam_role.s3_readonly_role.arn} --role-session-name VerifyRole >/dev/null 2>&1 || echo 'Verification skipped'"
  }
}
