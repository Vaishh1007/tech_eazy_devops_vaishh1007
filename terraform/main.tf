resource "aws_instance" "assignment3_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.upload_profile.name

  tags = {
    Name = "Assignment3-Instance"
    Stage = var.stage
  }

  # OLD: inline user_data
  # user_data = <<-EOT
  #   ...
  # EOT

  # ✅ NEW: point to external script
  user_data = file("${path.module}/../scripts/user_data.sh")
}
