provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = file("${path.module}/../scripts/user_data.sh")

  tags = {
    Name = "AppServer"
  }
}
