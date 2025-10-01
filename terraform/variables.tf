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
  default = "vaishh-assignment3-bucket"
}

variable "stage" {
  description = "Deployment stage (dev, prod, etc.)"
  default     = "dev"
}
