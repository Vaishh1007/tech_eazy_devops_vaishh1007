# variables.tf for Assignment 2

variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c02fb55956c7d316"  # example Amazon Linux 2 AMI in ap-south-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS key pair name for SSH access"
  default     = "your-key-name"  # replace with your actual key pair name
}
