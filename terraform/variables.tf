variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 in ap-south-1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for logs"
  default     = "vaishh-assignment3-bucket-123" # must be globally unique
}

variable "stage" {
  description = "Deployment stage (dev, prod, etc.)"
  default     = "dev"
}
