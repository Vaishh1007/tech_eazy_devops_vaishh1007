variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Your AWS key pair name"
  default     = "my-key" # Change this to your key
}

variable "stage" {
  description = "Deployment stage"
  default     = "dev"
}

variable "shutdown_minutes" {
  description = "Minutes after which instance shuts down (0 = no shutdown)"
  default     = 0
}
