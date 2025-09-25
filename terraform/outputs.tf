output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.assignment2_instance.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.assignment2_bucket.bucket
}
